#!python
#cython: language_level=3

import struct
import time
from multiprocessing import shared_memory

import wx
from wx.lib.delayedresult import startWorker


class RenderApp(wx.App):
    def __init__(self):
        super(RenderApp, self).__init__()


class RenderFrame(wx.Frame):
    def __init__(self, app, size=(640, 480), title=""):
        super(RenderFrame, self
              ).__init__(None,
                         title=title,
                         style=(wx.DEFAULT_FRAME_STYLE) & ~(
                             wx.RESIZE_BORDER | wx.MAXIMIZE_BOX),
                         size=size)
        self.size = size
        self.bufsize = size[0] * size[1] * 3
        self.Bind(wx.EVT_CLOSE, self.OnExit)
        # self.Centre()

    def OnExit(self, event):
        wx.Exit()


class RenderPanel(wx.Panel):
    def __init__(self, parent, shm_buf, shm_time, sync_update):
        super(RenderPanel, self).__init__(parent, -1)
        self.shared_buffer = shm_buf
        self.shared_time = shm_time
        self.buffer_size = parent.bufsize
        self.sync_update = sync_update
        self.w, self.h = parent.size
        self.time = time.time()
        self.last = 0

        self.Bind(wx.EVT_PAINT, self.OnPaint)
        self.Bind(wx.EVT_SIZE, self.OnSize)
        self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)

        self.timer = wx.Timer(self)
        self.Bind(wx.EVT_TIMER, self.OnTimer, self.timer)
        # control = wx.StaticBitmap(self, -1, wx.Bitmap(1280, 720))
        self.SizeUpdate()

    def OnPaint(self, event):
        # Just draw prepared bitmap
        struct.pack_into(
            '<d', self.shared_time.buf[:8], 0,  time.time() - self.time)

        wx.BufferedPaintDC(self, wx.Bitmap.FromBuffer(
            self.w, self.h, self.shared_buffer.buf))

    def OnSize(self, event):
        pass

    def OnEraseBackground(self, event):
        pass

    def OnTimer(self, event):
        self.timer.Stop()
        self.sync_update[1].acquire()
        try:
            self.Refresh()
            self.Update()
        finally:
            self.sync_update[0].release()
        self.timer.Start(1)

    def SizeUpdate(self):
        self.timer.Stop()
        self.timer.Start(20)


class WindowManager():
    def __init__(self, synchros, shm_buf, shm_time, vp_size, buf_size):
        super(WindowManager, self).__init__()
        self.vp_size = vp_size
        self.sync_exit = synchros['exit']
        self.sync_update = synchros['update']
        self.shared_buffer = shared_memory.SharedMemory(name=shm_buf,
                                                        create=False)
        self.shared_time = shared_memory.SharedMemory(name=shm_time,
                                                      create=False)
        self.buf_size = buf_size
        self.app = None
        self.frame = None
        self.panel = None

    def create_window(self):
        if self.frame is None:
            self.app = RenderApp()
            self.frame = RenderFrame(self.app,
                                     size=self.vp_size,
                                     title='RENDERY BOY')  # size
            # the heavy lifter window-side
            self.panel = RenderPanel(self.frame,
                                     self.shared_buffer,
                                     self.shared_time,
                                     self.sync_update)  # buffers

    def start_window(self):
        print("WINDOW start")
        self.create_window()
        self.frame.Show()
        self.app.MainLoop()
        self.sync_exit.set()
        # make sure the computation thread can find the natural exit
        self.sync_update[0].acquire(block=False)
        self.sync_update[0].release()
        print("WINDOW exit")
        self.shared_buffer.close()
        self.shared_time.close()
        print("WINDOW stopped")

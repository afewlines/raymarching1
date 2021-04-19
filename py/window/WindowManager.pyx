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
        self.Bind(wx.EVT_CLOSE, self.OnExit)

    def OnExit(self, event):
        wx.Exit()


class RenderPanel(wx.Panel):
    def __init__(self, parent, shm_buf, shm_time, sync_update):
        super(RenderPanel, self).__init__(parent, -1)
        self.shared_buffer = shm_buf
        self.shared_time = shm_time
        self.sync_update = sync_update
        self.w, self.h = parent.size
        self.time = time.time()
        self.frames = 0

        self.buffered_image = wx.Bitmap.FromBuffer(self.w,
                                                   self.h,
                                                   self.shared_buffer.buf)

        self.Bind(wx.EVT_PAINT, self.OnPaint)
        self.Bind(wx.EVT_SIZE, self.OnSize)
        self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)

        self.timer = wx.Timer(self)
        self.Bind(wx.EVT_TIMER, self.OnTimer, self.timer)
        self.SizeUpdate()

    def OnPaint(self, event):
        wx.BufferedPaintDC(self, self.buffered_image)

    def OnSize(self, event):
        pass

    def OnEraseBackground(self, event):
        pass

    def OnTimer(self, event):
        self.timer.Stop()
        self.sync_update[1].acquire()
        try:
            # el critcal section
            self.buffered_image = wx.Bitmap.FromBuffer(self.w,
                                                       self.h,
                                                       self.shared_buffer.buf)
        finally:
            self.sync_update[0].release()

            # less than critical section
            struct.pack_into(
                '<d', self.shared_time.buf[:8], 0,  time.time() - self.time)
            self.Refresh()
            self.Update()

            # fps logic
            t = time.time()
            if t - self.time > 1:
                print(self.frames)
                self.time = t
                self.frames = 0
            else:
                self.frames += 1

        # poor man's threading
        self.timer.Start(0)

    def SizeUpdate(self):
        self.timer.Stop()
        self.timer.Start(20)


class WindowManager():
    def __init__(self, synchros, shm_buf, shm_time, vp_size):
        super(WindowManager, self).__init__()
        self.vp_size = vp_size
        self.sync_exit = synchros['exit']
        self.sync_update = synchros['update']
        self.shared_buffer = shared_memory.SharedMemory(name=shm_buf,
                                                        create=False)
        self.shared_time = shared_memory.SharedMemory(name=shm_time,
                                                      create=False)
        self.app = None
        self.frame = None
        self.panel = None

    def create_window(self):
        if self.frame is None:
            self.app = RenderApp()
            self.frame = RenderFrame(self.app,
                                     size=self.vp_size,
                                     title='RENDERY BOY')
            # the heavy lifter window-side
            self.panel = RenderPanel(self.frame,
                                     self.shared_buffer,
                                     self.shared_time,  # buffers
                                     self.sync_update)

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

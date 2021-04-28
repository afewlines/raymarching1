#!python
#cython: language_level=3

import struct
import time
from multiprocessing import shared_memory
from pathlib import Path

import wx
from wx.lib.delayedresult import startWorker


class RenderApp(wx.App):
    def __init__(self):
        super(RenderApp, self).__init__()

    # def OnExit(event):
    #     print("Exit App")


class RenderFrame(wx.Frame):
    def __init__(self, app, size=(640, 480), title=""):
        size = (size[0], size[1] + 40)
        super(RenderFrame, self
              ).__init__(None,
                         title=title,
                         style=(wx.DEFAULT_FRAME_STYLE) & ~(
                             wx.RESIZE_BORDER | wx.MAXIMIZE_BOX),
                         size=size)
        self.size = size
        self.Bind(wx.EVT_CLOSE, self.OnExit)

    def OnExit(self, event):
        print("Exit Frame")
        wx.Exit()


class RenderPanel(wx.Panel):
    def __init__(self, parent, size, shm_buf, shm_time, sync_update, sync_exit):
        super(RenderPanel, self).__init__(parent, -1)
        self.shared_buffer = shm_buf
        self.shared_time = shm_time
        self.sync_update = sync_update
        self.sync_exit = sync_exit
        self.w, self.h = size
        self.time = time.time()
        self.total_frames = 0

        self.current_image = -1
        self.buffered_images = []

        self.Bind(wx.EVT_PAINT, self.OnPaint)
        self.Bind(wx.EVT_SIZE, self.OnSize)
        self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)

        self.timer = wx.Timer(self)
        self.Bind(wx.EVT_TIMER, self.OnTimer, self.timer)
        self.sync_update[0].release()  # off to the horses
        self.timer.Start(1)

    def OnPaint(self, event):
        if len(self.buffered_images) > 0:
            wx.BufferedPaintDC(self, self.buffered_images[self.current_image])

    def OnSize(self, event):
        pass

    def OnEraseBackground(self, event):
        pass

    def OnTimer(self, event):
        self.timer.Stop()

        #
        #
        # handle exit/display
        if self.sync_exit.is_set():
            self.current_image = (self.current_image + 1) % self.total_frames

            # fps logic
            # print("{:.2f}".format(t - self.time))

            self.Refresh()
            # self.Update()

            t = time.time()
            self.timer.Start((1 / 30 * 1000) - (t - self.time))
            self.time = t
            return

        #
        #
        #
        # rest of on timer function handles render
        self.time = time.time()
        try:
            self.sync_update[1].acquire()

            # el critcal section
            self.buffered_images.append(wx.Bitmap.FromBuffer(
                self.w,
                self.h,
                self.shared_buffer.buf,
            ))
            self.total_frames += 1
            struct.pack_into(
                '<i', self.shared_time.buf[:4], 0, self.total_frames)
        finally:
            self.sync_update[0].release()
            # less than critical section
            self.Refresh()
            self.Update()
            self.buffered_images[-1].SaveFile(
                "./out/bin/frame{:05}.bmp".format(self.total_frames - 1),
                wx.BITMAP_TYPE_BMP,
            )
            print("Frame {:05}, {:.4f}s".format(
                self.total_frames - 1, time.time() - self.time))

        # poor man's threading
        self.timer.Start(1)

    # def SizeUpdate(self):
    #     self.timer.Stop()
    #     self.timer.Start(20)


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
                                     self.vp_size,
                                     self.shared_buffer,
                                     self.shared_time,  # buffers
                                     self.sync_update,
                                     self.sync_exit)

    def start_window(self):
        print("WINDOW start")
        self.create_window()
        self.frame.Show()
        try:
            self.app.MainLoop()
        except Exception as e:
            print("oh no")
            print(e)
        finally:
            # make sure the computation thread can find the natural exit
            print("WINDOW exit")
            self.shared_buffer.close()
            self.shared_time.close()
            print("WINDOW stopped")
            self.sync_exit.set()
            self.sync_update[0].acquire(block=False)
            self.sync_update[0].release()

#!python
#cython: language_level=3

import multiprocessing
import struct
import time
from multiprocessing import shared_memory

import WindowManager
from ComputeWrapper import PyComputer


def compute_handler(synchros, shm_buf, shm_time, vp_size, buf_size):
    """Main runner for pixel computation; repeatedly calls to
    ComputeWrapper to update a given section of memory.
    """
    print("COMPUTE start")
    t1 = 1
    shared_buffer = shared_memory.SharedMemory(name=shm_buf,
                                               create=False)
    shared_time = shared_memory.SharedMemory(name=shm_time,
                                             create=False)
    sync_exit = synchros['exit']
    sync_update = synchros['update']

    _computer = PyComputer()
    _computer.set_buffer_image(shared_buffer.buf)
    _computer.set_vp_size(*vp_size)

    try:
        while True:
            sync_update[0].acquire()
            if sync_exit.is_set():
                break

            # t1 += ComputeWrapper.compute_frame(shared_buffer.buf,
            #                                    shared_time.buf,
            #                                    *vp_size)

            t1 += _computer.calculate_frame(time.time())

            sync_update[1].release()

    except KeyboardInterrupt:
        print("COMPUTE terminated")
    finally:
        print("COMPUTE exit")
        shared_buffer.close()
        shared_time.close()

    print("COMPUTE stopped")


class RenderManager():
    def __init__(self, size):
        self.vp_size = size
        self.buf_size = self.vp_size[0] * self.vp_size[1] * 3
        # self.s_exit =multiprocessing.Event()
        # self.s_update = multiprocessing.Lock()
        # one event to alert engine of natural shutdown
        # two locks for render/display
        self.synchros = {'exit': multiprocessing.Event(),
                         'update': [multiprocessing.Lock(), multiprocessing.Lock()]}
        # tell display to wait for first update
        self.synchros['update'][1].acquire()

        self.shm_buf = shared_memory.SharedMemory(name='imagebuffer',
                                                  create=True,
                                                  size=self.buf_size)
        self.shm_time = shared_memory.SharedMemory(name='time',
                                                   create=True,
                                                   size=8)
        self.window = WindowManager.WindowManager(self.synchros,  # UPDATE THIS
                                                  self.shm_buf.name,
                                                  self.shm_time.name,
                                                  self.vp_size,
                                                  self.buf_size)

    def start(self):
        p_window = multiprocessing.Process(
            target=self.window.start_window,
        )

        p_compute = multiprocessing.Process(
            target=compute_handler,
            args=(self.synchros,
                  self.shm_buf.name,
                  self.shm_time.name,
                  self.vp_size,
                  self.buf_size),
        )

        # wrap the processes to
        # make sure shared memory
        # is closed & freed
        try:
            p_window.start()
            p_compute.start()
            p_compute.join()
            p_window.join()
        except KeyboardInterrupt:
            print("APPLICATION TERMINATED")
        finally:
            self.shm_buf.close()
            self.shm_time.close()
            self.shm_buf.unlink()
            self.shm_time.unlink()


if __name__ == '__main__':
    print("heysds")

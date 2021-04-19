#!python
#cython: language_level=3

import multiprocessing
import struct
import time
from multiprocessing import shared_memory

import ComputeWrapper
import WindowManager
import WorldManager


class RenderManager():
    def __init__(self, size):
        # viewport size in pixels
        self.vp_size = size
        self.scene = WorldManager.DemoScene()

        # exit alert, render loop locks
        self.synchros = {'exit': multiprocessing.Event(),
                         'update': [multiprocessing.Lock(), multiprocessing.Lock()]}
        # tell display to wait for first update
        self.synchros['update'][1].acquire()

        # acquire shared memory
        self.shm_buf = shared_memory.SharedMemory(name='imagebuffer',
                                                  create=True,
                                                  size=self.vp_size[0] * self.vp_size[1] * 3)
        self.shm_time = shared_memory.SharedMemory(name='time',
                                                   create=True,
                                                   size=8)

        # init managers
        self.window = WindowManager.WindowManager(self.synchros,
                                                  self.shm_buf.name,
                                                  self.shm_time.name,
                                                  self.vp_size)
        self.computer = ComputeWrapper.PyComputer()

        self.computer.set_buffer_image(self.shm_buf.buf)
        self.computer.set_vp_size(*self.vp_size)

    def compute_handler(self):
        """Main runner for pixel computation; repeatedly calls to
        ComputeWrapper to update a given section of memory.
        """
        print("COMPUTE start")

        update = self.synchros['update']
        exit = self.synchros['exit']
        world = self.scene.get_world()
        world.deets()
        # self.computer.set_world(world) #we are here on this commit

        try:
            while True:
                update[0].acquire()
                if exit.is_set():
                    break

                self.computer.calculate_frame(time.time())

                update[1].release()

        except KeyboardInterrupt:
            print("COMPUTE terminated")
        finally:
            print("COMPUTE exit")
            # shared_buffer.close()
            # shared_time.close()

        print("COMPUTE stopped")

    def start(self):
        p_window = multiprocessing.Process(
            target=self.window.start_window
        )

        # wrap the processes to
        # make sure shared memory
        # is closed & freed
        try:
            p_window.start()

            # call the compute, may move again later :/
            self.compute_handler()

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

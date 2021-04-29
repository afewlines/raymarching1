#!python
#cython: language_level=3

import multiprocessing
import struct
import time
from multiprocessing import shared_memory

from pymarch.compute.ComputeWrapper import PyComputer
from pymarch.WindowManager import WindowManager
from pymarch.WorldManager import SceneDemo

# from PyWrappers import ComputeWrapper, WindowManager, WorldManager


class RenderManager():
    def __init__(self, size):
        # viewport size in pixels
        self.vp_size = size
        self.scene = SceneDemo()

        # exit alert, render loop locks
        self.synchros = {'exit': multiprocessing.Event(),
                         'update': [multiprocessing.Lock(), multiprocessing.Lock()]}
        # tell display to wait for first update
        self.synchros['update'][0].acquire()
        self.synchros['update'][1].acquire()

        # acquire shared memory
        self.shm_buf = shared_memory.SharedMemory(name='imagebuffer',
                                                  create=True,
                                                  size=self.vp_size[0] * self.vp_size[1] * 3)
        self.shm_time = shared_memory.SharedMemory(name='time',
                                                   create=True,
                                                   size=4)

        # init managers
        self.window = WindowManager(self.synchros,
                                    self.shm_buf.name,
                                    self.shm_time.name,
                                    self.vp_size)
        self.computer = PyComputer()

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
        self.computer.set_world(world)  # we are here on this commit

        try:
            while not exit.is_set():
                update[0].acquire()
                try:
                    self.scene.frame = struct.unpack(
                        '<i', self.shm_time.buf)[0]
                    if self.scene._render_loop():
                        self.computer.calculate_frame()
                    else:
                        print("RENDER LOOP exit signal")
                        break  # render loop said close :(
                except KeyboardInterrupt:
                    raise
                finally:
                    update[1].release()

        except KeyboardInterrupt:
            print("COMPUTE terminated")
            raise
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

        except KeyboardInterrupt:
            pass
        finally:
            self.synchros['exit'].set()
            self.synchros['update'][1].acquire(block=False)
            self.synchros['update'][1].release()
            try:
                p_window.join()
            except KeyboardInterrupt:
                pass
            print("APPLICATION TERMINATED")
            self.shm_buf.close()
            self.shm_time.close()
            self.shm_buf.unlink()
            self.shm_time.unlink()


if __name__ == '__main__':
    print("heysds")

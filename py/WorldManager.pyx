#!python
#cython: language_level=3

import math
from multiprocessing import managers
from multiprocessing.managers import (AutoProxy, BaseManager, MakeProxyType,
                                      SyncManager, public_methods)

# import MPPatch
from WorldWrapper import (PyPrimitivePlane, PyPrimitiveSphere,
                          PyRenderableObject, PyWorld, PyWorldManager)


class DemoScene(PyWorldManager):
    def __init__(self):
        self.world = PyWorld()

        ground = PyPrimitivePlane()
        ball = PyPrimitiveSphere()

        ground.set_position(0, 0, 0)
        ball.set_position(1, 2, 5)
        ball.set_radius(1)

        self.world.add(ground)
        self.world.add(ball)
        self.select_world(self.world)
        ball.set_position(1, 2, 8)


#
# def get_demo_scene2():
#     manager = UpperManagement()
#     manager.start()
#     wm = manager.WorldManager()
#     world = manager.World()
#     ground = manager.PrimitivePlane()
#     ball = manager.PrimitiveSphere()
#
#     ground.set_position(0, 0, 0)
#     ball.set_position(1, 2, 5)
#     ball.set_radius(1)
#
#     print(ground)
#     print(dir(ground))
#     input()
#     world.add(ground)
#     world.add(ball)
#     wm.select_world(world)
#     ball.set_position(1, 2, 8)
#
#     return (manager, wm,)

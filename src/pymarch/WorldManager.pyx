#!python
#cython: language_level=3

import math

from pymarch.world.WorldWrapper import (PyPrimitivePlane, PyPrimitiveSphere,
                                        PyRenderableObject, PyWorld,
                                        PyWorldManager)


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

#!python
#cython: language_level=3

import math

from pymarch.world.WorldWrapper import (PyCamera, PyPointLight,
                                        PyPrimitivePlane, PyPrimitiveSphere,
                                        PyWorld, PyWorldManager)


class DemoScene(PyWorldManager):
    def __init__(self):
        self.world = PyWorld()
        self.world.set_world_paramaters(150, 0.01, 50, 0.001)
        self.framerate = 30
        self.time = 0

        self.camera_z = 0

        self.camera = PyCamera()
        self.camera.zoom = 0.8
        # self.camera.set_position(0, 3, self.camera_z)
        # self.camera.set_rotation(0, 0, 0)
        self.world.set_camera(self.camera)

        # self.ground = PyPrimitivePlane()
        # self.ground.set_position(0, 0, 0)
        # self.ground.set_color(0.84, 0.85, 0.78)
        # self.world.add_object(self.ground)

        self.ball = PyPrimitiveSphere()
        self.ball.set_radius(1)
        self.ball.set_position(0, 0, 0)
        self.ball.set_color(0.46, 0.58, 0.46)
        self.world.add_object(self.ball)

        self.b2 = PyPrimitiveSphere()
        self.b2.set_radius(0.3)
        self.b2.set_position(0.4, 0.3, -1.1)
        self.b2.set_color(0.58, 0.49, 0.62)
        self.world.add_object(self.b2)

        self.light1 = PyPointLight()
        # self.light1.set_position(-8, 3, 8)
        self.world.add_light(self.light1)

        self.select_world(self.world)
        # ball.set_position(1, 2, 8)

    def _render_loop(self):
        self.time = self.frame / self.framerate
        self.camera_z = 1.25 * self.time

        self.camera.set_position(0, 2, self.camera_z)
        self.camera.set_rotation(0, 0, self.time * 3.14 / 8)
        self.light1.set_position(
            math.cos(self.time * 3.14 / 8) * 7,
            (math.sin(self.time * 3.14 / 8) * 7) + 2,
            self.camera_z + 16)

        return self.frame <= 480

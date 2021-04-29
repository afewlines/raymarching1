#!python
#cython: language_level=3

import math

from pymarch.world.WorldWrapper import (
    PyCamera, PyPointLight, PyPrimitiveBox, PyPrimitivePlane,
    PyPrimitiveSphere, PyWorld, PyWorldManager)


class SceneDemo(PyWorldManager):
    def __init__(self):
        self.world = PyWorld()
        self.world.set_world_paramaters(200, 0.01, 200, 0.001)
        self.framerate = 30
        self.time = 0

        self.camera_rot = 0

        self.camera = PyCamera()
        self.camera.zoom = 1
        # self.camera.set_rotation(0.12, 0, 0)
        self.world.set_camera(self.camera)

        # ground
        self.ground = PyPrimitivePlane()
        self.ground.set_position(0, 0, 0)
        self.ground.set_color(0.84, 0.85, 0.78)
        self.world.add_object(self.ground)

        #
        # ball
        self.item1 = PyPrimitiveSphere()
        # self.item1.set_size(1, 1, 1)
        self.item1.set_radius(1)
        self.item1.set_position(-1, 1, 1)
        self.item1.set_color(0.22, 0.34, 0.96)
        self.world.add_object(self.item1)

        # cube
        self.item2 = PyPrimitiveBox()
        self.item2.set_size(0.6, 0.6, 0.6)
        # self.item2.set_radius(0.6)
        self.item2.set_position(0.3, 0.6, -0.8)
        self.item2.set_color(0.76, 0.24, 0.24)
        self.world.add_object(self.item2)

        #
        # light 1
        self.light1 = PyPointLight()
        self.light1.set_position(4, 5, -8)
        self.world.add_light(self.light1)

        # light 2
        self.light2 = PyPointLight()
        self.light2.set_position(-10, 3, 2)
        self.world.add_light(self.light2)

        # light 3
        self.light3 = PyPointLight()
        self.light3.set_position(0, 16, 0)
        self.world.add_light(self.light3)

        self.select_world(self.world)

    def _render_loop(self):
        self.time = self.frame / self.framerate
        self.camera_rot = self.time * math.pi / 4

        self.camera.set_position(
            math.sin(self.camera_rot) * 6,
            2.5,
            math.cos(self.camera_rot) * -6)
        self.camera.set_rotation(0.15, self.camera_rot, 0)

        return self.frame <= 2 * self.framerate * 4


class SceneBrinyDeep(PyWorldManager):
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

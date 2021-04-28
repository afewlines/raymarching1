#!python
#cython: language_level=3

from cython.operator cimport dereference
from libcpp cimport bool

#
# BASE TYPES

cdef class PyRenderableObject:
    def __cinit__(self):
        if type(self) is PyRenderableObject:
            self.ptr_obj = new RenderableObject()

    def __dealloc__(self):
        if type(self) is PyRenderableObject:
            del self.ptr_obj

    def get_position(self):
        cdef float pos[3]
        self.ptr_obj.get_position(pos)
        return pos

    def get_rotation(self):
        cdef float rot[3]
        self.ptr_obj.get_rotation(rot)
        return rot

    def set_position(self, x, y, z):
        self.ptr_obj.set_position(x, y, z)

    def set_rotation(self, x, y, z):
        self.ptr_obj.set_rotation(x, y, z)

    def set_color(self, r, g, b):
        self.ptr_obj.set_color(r, g, b)

    # Attribute access
    @property
    def id(self):
        return self.ptr_obj.id

cdef class PyControlObject:
    def __cinit__(self):
        if type(self) is PyControlObject:
            self.ptr_obj = new ControlObject()

    def __dealloc__(self):
        if type(self) is PyControlObject:
            del self.ptr_obj

    def get_position(self):
        cdef float pos[3]
        self.ptr_obj.get_position(pos)
        return pos

    def get_rotation(self):
        cdef float rot[3]
        self.ptr_obj.get_rotation(rot)
        return rot

    def set_position(self, float x, float y, float z):
        self.ptr_obj.set_position(x, y, z)

    def set_rotation(self, float x, float y, float z):
        self.ptr_obj.set_rotation(x, y, z)

cdef class PyWorld:
    def __cinit__(self):
        self.ptr_world = new World()

    def __dealloc__(self):
        del self.ptr_world

    def set_world_paramaters(self, steps, min_dist, max_dist, threshold):
        self.ptr_world.max_steps = steps
        self.ptr_world.min_distance = min_dist
        self.ptr_world.max_distance = max_dist
        self.ptr_world.threshold = threshold

    def deets(self):
        self.ptr_world.deets()

    cdef void _add_object(self, PyRenderableObject target):
        self.ptr_world.add_object(target.ptr_obj)

    def add_object(self, target):
        self._add_object(target)

    cdef void _add_light(self, PyLight target):
        self.ptr_world.add_light(target.ptr_light)

    def add_light(self, target):
        self._add_light(target)

    cdef void _set_camera(self, PyCamera target):
        self.ptr_world.active_camera = target.ptr_camera

    def set_camera(self, target):
        self._set_camera(target)


#
# MANAGERS

cdef class PyWorldManager:
    def __cinit__(self):
        self.ptr_wman = new WorldManager()
        self.frame = 0

    def __dealloc__(self):
        del self.ptr_wman

    cpdef PyWorld get_world(self):
        return self.active_world

    cdef void _select_world(self, PyWorld world):
        self.active_world = world
        self.ptr_wman.active_world = world.ptr_world

    def select_world(self, world):
        self._select_world(world)

    def _render_loop(self):
        pass

    def ping(self):
        if self.active_world:
            self.active_world.deets()
        else:
            print("World Not Loaded")

#
# RENDERABLE PRIMITIVES

cdef class PyPrimitivePlane(PyRenderableObject):
    def __cinit__(self):
        if type(self) is PyPrimitivePlane:
            self.ptr_obj = self.ptr_plane = new PrimitivePlane()

    def __dealloc__(self):
        if type(self) is PyPrimitivePlane:
            del self.ptr_plane

    def get_size(self):
        cdef float size[2]
        self.ptr_plane.get_size(size)
        return size

    def set_size(self, w, h):
        self.ptr_plane.set_size(w, h)

cdef class PyPrimitiveSphere(PyRenderableObject):
    def __cinit__(self):
        if type(self) is PyPrimitiveSphere:
            self.ptr_obj = self.ptr_sphere = new PrimitiveSphere()

    def __dealloc__(self):
        if type(self) is PyPrimitiveSphere:
            del self.ptr_sphere

    def get_radius(self):
        return self.ptr_sphere.radius

    def set_radius(self, w):
        self.ptr_sphere.radius = w

#
# CONTROL OBJECTS
cdef class PyCamera(PyControlObject):
    def __cinit__(self):
        if type(self) is PyCamera:
            self.ptr_obj = self.ptr_camera = new Camera()

    def __dealloc__(self):
        if type(self) is PyCamera:
            del self.ptr_camera

    # Attribute access
    @property
    def zoom(self):
        return self.ptr_camera.zoom

    @zoom.setter
    def zoom(self, level):
        self.ptr_camera.zoom = level

cdef class PyLight(PyControlObject):
    def __cinit__(self):
        if type(self) is PyLight:
            self.ptr_obj = self.ptr_light = new Light()

    def __dealloc__(self):
        if type(self) is PyLight:
            del self.ptr_light

cdef class PyPointLight(PyLight):
    def __cinit__(self):
        if type(self) is PyPointLight:
            self.ptr_obj = self.ptr_light = self.ptr_lpoint = new PointLight()

    def __dealloc__(self):
        if type(self) is PyPointLight:
            del self.ptr_lpoint

    cpdef void set_color(self, float r, float g, float b):
        self.ptr_lpoint.set_color(r, g, b)

    cpdef void set_grayscale(self, float value):
        self.set_color(value, value, value)

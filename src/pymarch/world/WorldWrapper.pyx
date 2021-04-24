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

    def set_position(self, float x, float y, float z):
        self.ptr_obj.set_position(x, y, z)

    def set_rotation(self, float x, float y, float z):
        self.ptr_obj.set_rotation(x, y, z)

    # Attribute access
    @property
    def id(self):
        return self.ptr_obj.id

cdef class PyWorld:
    def __cinit__(self):
        self.ptr_world = new World()

    def __dealloc__(self):
        del self.ptr_world

    def deets(self):
        self.ptr_world.deets()

    cdef void _add_object(self, PyRenderableObject target):
        target.ptr_obj = self.ptr_world.add_object(target.ptr_obj)

    def add(self, target):
        self._add_object(target)


#
# MANAGERS

cdef class PyWorldManager:
    def __cinit__(self):
        self.ptr_wman = new WorldManager()

    def __dealloc__(self):
        del self.ptr_wman

    def ping(self):
        if self.active_world:
            self.active_world.deets()
        else:
            print("World Not Loaded")

    cpdef PyWorld get_world(self):
        return self.active_world

    cdef void _select_world(self, PyWorld world):
        self.active_world = world
        self.ptr_wman.active_world = world.ptr_world

    def select_world(self, world):
        self._select_world(world)


#
# PRIMITIVES

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

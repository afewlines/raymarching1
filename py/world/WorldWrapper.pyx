#!python
#cython: language_level=3
cimport WorldWrapper
from cython.operator cimport dereference
from libcpp cimport bool

#
# BASE TYPES

cdef class PyRenderableObject:
    cdef RenderableObject * ptr_obj  # pointer to class

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

    cpdef void set_position(self, float x, float y, float z):
        self.ptr_obj.set_position(x, y, z)

    cpdef void set_rotation(self, float x, float y, float z):
        self.ptr_obj.set_rotation(x, y, z)

    # Attribute access
    @property
    def id(self):
        return self.ptr_obj.id

cdef class PyWorld:
    cdef World * ptr_world

    def __cinit__(self):
        self.ptr_world = new World()

    def __dealloc__(self):
        del self.ptr_world

    cpdef deets(self):
        self.ptr_world.deets()

    cdef _add_object(self, PyRenderableObject target):
        target.ptr_obj = self.ptr_world.add_object(target.ptr_obj)

    cpdef add(self, target):
        self._add_object(target)


#
# MANAGERS

cdef class PyWorldManager:
    cdef WorldManager * ptr_wman
    cdef PyWorld active_world

    def __cinit__(self):
        self.ptr_wman = new WorldManager()

    def __dealloc__(self):
        del self.ptr_wman

    cpdef void ping(self):
        if self.active_world:
            self.active_world.deets()
        else:
            print("World Not Loaded")

    cpdef PyWorld get_world(self):
        return self.active_world

    cdef void _sel(self):
        self.ptr_wman.active_world = self.active_world.ptr_world

    cpdef void select_world(self, PyWorld world):
        self.active_world = world
        self._sel()


#
# PRIMITIVES

cdef class PyPrimitivePlane(PyRenderableObject):
    cdef PrimitivePlane * ptr_plane  # pointer to class

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

    cpdef void set_size(self, float w, float h):
        self.ptr_plane.set_size(w, h)

cdef class PyPrimitiveSphere(PyRenderableObject):
    cdef PrimitiveSphere * ptr_sphere  # pointer to class

    def __cinit__(self):
        if type(self) is PyPrimitiveSphere:
            self.ptr_obj = self.ptr_sphere = new PrimitiveSphere()

    def __dealloc__(self):
        if type(self) is PyPrimitiveSphere:
            del self.ptr_sphere

    cpdef float get_radius(self):
        return self.ptr_sphere.radius

    cpdef void set_radius(self, float w):
        self.ptr_sphere.radius = w

#!python
#cython: language_level=3


cdef class PyComputer:
    cpdef calculate_frame(self, double time):
        return self.thisptr.compute_frame(time)

    cpdef void set_buffer_image(self, char[:] buf):
        self.thisptr.set_buffer_image( & buf[0])

    def set_vp_size(self, w, h):
        self.thisptr.set_vp_size(w, h)

    cdef void _set_world(self, PyWorld world):
        self.active_world = world
        self.thisptr.active_world = world.ptr_world

    def set_world(self, world):
        self._set_world(world)

    # Attribute access
    @property
    def mod(self):
        return self.thisptr.mod

    @mod.setter
    def mod(self, mod):
        self.thisptr.mod = mod

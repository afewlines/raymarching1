#!python
#cython: language_level=3

cimport ComputeWrapper


cdef class PyComputer:
    cdef Computer thisptr  # pointer to Computer class,

    def __cinit__(self):
        self.thisptr = Computer()  # allocate to stack by not using new

    cpdef calculate_frame(self, double time):
        return self.thisptr.compute_frame(time)

    cpdef void set_buffer_image(self, char[:] buf):
        self.thisptr.set_buffer_image( & buf[0])

    cpdef void set_vp_size(self, int w, int h):
        self.thisptr.set_vp_size(w, h)

    # Attribute access
    @property
    def mod(self):
        return self.thisptr.mod

    @mod.setter
    def mod(self, mod):
        self.thisptr.mod = mod

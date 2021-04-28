#!python
#cython: language_level=3

from pymarch.world.WorldWrapper cimport PyWorld, World


cdef extern from "../../c/Compute/Computer.h":
    cdef cppclass Computer:
        int mod
        World * active_world

        Computer() except +

        void set_vp_size(int w, int h)
        void set_buffer_image(char * buf)
        void update_mod(int n)

        void compute_frame()
        void compute_frame_bounded(int lox, int hix, int lowy, int hiy)


cdef class PyComputer:
    cdef Computer thisptr
    cdef PyWorld active_world
    cdef int w
    cdef int h

    cpdef void calculate_frame(self)
    cpdef void calculate_frame_bounded(self, int vdiv, int hdiv)
    cdef void _set_world(self, PyWorld world)
    cpdef void set_buffer_image(self, char[:] buf)

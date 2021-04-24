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

        int compute_frame(double time)


cdef class PyComputer:
    cdef Computer thisptr
    cdef PyWorld active_world

    cpdef calculate_frame(self, double time)
    cdef void _set_world(self, PyWorld world)
    cpdef void set_buffer_image(self, char[:] buf)

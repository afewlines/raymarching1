#!python
#cython: language_level=3

cdef extern from "../../c/Compute/Computer.h":
    cdef cppclass Computer:
        int mod

        Computer() except +

        void set_vp_size(int w, int h)
        void set_buffer_image(char * buf)
        void update_mod(int n)

        int compute_frame(double time)

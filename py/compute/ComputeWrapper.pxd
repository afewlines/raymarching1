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


# cdef class ComputeWrapper:
#     cdef Computer * obj
#
#     def __init__(self):
#         self.cobj = new Computer()
#         if self.cobj == NULL:
#             raise MemoryError('Not enough memory.')
#
#     def __del__(self):
#         del self.cobj

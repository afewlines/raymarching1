#!python
#cython: language_level=3
# from libc.math cimport floor
import multiprocessing as mp


cdef class PyComputer:
    cpdef void calculate_frame(self):
        self.thisptr.compute_frame()

    cpdef void calculate_frame_bounded(self, int vdiv, int hdiv):
        cdef int lox, hix, loy, hiy
        cdef int cols_y = int(self.h / vdiv)
        cdef int cols_x = int(self.w / hdiv)
        cdef int spot_y = 0
        cdef int spot_x = 0
        # print(cols_x, cols_y)

        for offy in range(vdiv):
            for offx in range(hdiv):
                self.thisptr.compute_frame_bounded(
                    spot_x,
                    spot_x + cols_x,
                    spot_y,
                    spot_y + cols_y)
                spot_x = spot_x + cols_x
            spot_x = 0
            spot_y = spot_y + cols_y

    cpdef void set_buffer_image(self, char[:] buf):
        self.thisptr.set_buffer_image(& buf[0])

    def set_vp_size(self, w, h):
        self.w = w
        self.h = h

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

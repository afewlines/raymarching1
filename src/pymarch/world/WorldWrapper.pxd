#!python
#cython: language_level=3

from libcpp.string cimport string


# BASE OBJECTS
cdef extern from "../../c/Objects/RenderableObject.h" namespace "WorldObjects":
    cdef cppclass RenderableObject:
        int id

        RenderableObject() except +

        # pos
        void get_position(float[])
        void set_position(float, float, float)

        # rot
        void get_rotation(float[])
        void set_rotation(float, float, float)

        # color
        void set_color(float, float, float)

cdef extern from "../../c/Objects/ControlObject.h" namespace "WorldObjects":
    cdef cppclass ControlObject:
        int id

        ControlObject() except +

        # pos
        void get_position(float[])
        void set_position(float, float, float)

        # rot
        void get_rotation(float[])
        void set_rotation(float, float, float)


# EXPANDED BASE OBJECTS
cdef extern from "../../c/Objects/RenderablePrimitives.h" namespace "WorldObjects":
    cdef cppclass PrimitivePlane(RenderableObject):
        PrimitivePlane() except +

        # modifiable properties
        void get_size(float[])
        void set_size(float, float)

    cdef cppclass PrimitiveSphere(RenderableObject):
        float radius

        PrimitiveSphere() except +

        # modifiable properties
        float get_radius()
        void set_radius(float)

cdef extern from "../../c/Objects/Cameras.h" namespace "WorldObjects":
    cdef cppclass Camera(ControlObject):
        float zoom

        Camera() except +

cdef extern from "../../c/Objects/Lights.h" namespace "WorldObjects":
    cdef cppclass Light(ControlObject):
        Light() except +

    cdef cppclass PointLight(Light):
        float intensity
        PointLight() except +

        void set_color(float r, float g, float b)


# WORLD BASE OBJECT
cdef extern from "../../c/Objects/World.h":
    cdef cppclass World:
        Camera * active_camera
        int max_steps
        float min_distance
        float max_distance
        float threshold

        World() except +

        void add_object(RenderableObject *)
        void add_light(Light *)
        void deets()

    cdef cppclass WorldManager:
        World * active_world

        WorldManager() except +

        void select_world(World *)


# EXTENSION TYPES
cdef class PyRenderableObject:
    cdef RenderableObject * ptr_obj

cdef class PyControlObject:
    cdef ControlObject * ptr_obj

cdef class PyPrimitivePlane(PyRenderableObject):
    cdef PrimitivePlane * ptr_plane

cdef class PyPrimitiveSphere(PyRenderableObject):
    cdef PrimitiveSphere * ptr_sphere

cdef class PyCamera(PyControlObject):
    cdef Camera * ptr_camera

cdef class PyLight(PyControlObject):
    cdef Light * ptr_light

cdef class PyPointLight(PyLight):
    cdef PointLight * ptr_lpoint
    cpdef void set_color(self, float r, float g, float b)
    cpdef void set_grayscale(self, float value)

cdef class PyWorld:
    cdef World * ptr_world
    cdef void _add_object(self, PyRenderableObject target)
    cdef void _set_camera(self, PyCamera target)
    cdef void _add_light(self, PyLight target)
    # cpdef deets(self)

cdef class PyWorldManager:
    cdef WorldManager * ptr_wman
    cdef PyWorld active_world
    cdef int frame
    # cpdef void ping(self)
    cpdef PyWorld get_world(self)
    cdef void _select_world(self, PyWorld world)
    # cpdef void select_world(self, world)

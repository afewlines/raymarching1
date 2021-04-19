#!python
#cython: language_level=3
from libcpp.string cimport string


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


cdef extern from "../../c/Objects/World.h":
    cdef cppclass World:
        World() except +
        World(char * ) except +

        void set_title(char *)
        RenderableObject * add_object(RenderableObject *)
        void deets()

    cdef cppclass WorldManager:
        World * active_world

        WorldManager() except +

        void select_world(World *)

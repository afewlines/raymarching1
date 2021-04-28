#ifndef COBJECT_H
#define COBJECT_H
#include "../DataStructures/vec3.h"
#include <cstdint>

namespace WorldObjects {
class ControlObject {
	public:
		static int _count;

		int id;
		VectorMath::vec3 position;
		VectorMath::vec3 rotation;

		ControlObject() { this->id = _count++; }

		// wrapping functions
		void get_position( float [] );
		void get_rotation( float [] );
		void set_position( float, float, float );
		void set_rotation( float, float, float );
};
}


#endif

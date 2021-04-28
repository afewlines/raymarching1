#ifndef COBJECTCAMERAS_H
#define COBJECTCAMERAS_H
#include "ControlObject.h"

namespace WorldObjects {
class Camera :public ControlObject {
	public:
		float zoom;

		Camera() { this->zoom = 1.0; }

		VectorMath::vec3 get_lookat( float, float );
};
}


#endif

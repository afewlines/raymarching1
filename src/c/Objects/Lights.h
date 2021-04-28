#ifndef COBJECTLIGHTS_H
#define COBJECTLIGHTS_H
#include "../DataStructures/Color.h"
#include "ControlObject.h"
#include <cstdint>
#include <string>

namespace WorldObjects {
class Light :public ControlObject {
	public:
		Light() {}
};

class PointLight :public Light {
	public:
		float intensity;
		COLOR color;
		PointLight() { intensity = 1.0f;set_color( 0.95f, 0.91f, 0.85f ); }

		void set_color( float r, float g, float b ) { color.r = r;color.g = g;color.b = b; }
};
}


#endif

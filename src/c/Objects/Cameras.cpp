#include "Cameras.h"

namespace WorldObjects {
// wrapping functions
VectorMath::vec3 Camera::get_lookat( float u, float v ) {
	VectorMath::vec3 out( u, v, this->zoom );

	out.rotate_by_euler( this->rotation );
	return ( out.normalize() );
} // Camera::get_lookat
}

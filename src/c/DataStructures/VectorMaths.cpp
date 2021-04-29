#include "VectorMaths.h"

namespace VectorMath {
float min( float x, float y ) {
	if ( x >= y ) {
		return ( y );
	}
	return ( x );
} // min

float max( float x, float y ) {
	if ( x >= y ) {
		return ( x );
	}
	return ( y );
} // max

float sminCubic( float a, float b, float k ) {
	float h = max( k - abs( a - b ), 0.0f ) / k;

	return ( min( a, b ) - h * h * h * k * ( 1.f / 6.0f ) );
} // sminCubic

float clamp( float x, float min, float max ) {
	if ( x < min ) {
		x = min;
	}
	if ( x > max ) {
		x = max;
	}
	return ( x );
} // clamp

float falloff_scale( float x, float scale ) {
	// return ( 1.0f - ( scale / ( x + scale ) ) );
	return ( 1.0f + ( scale / ( ( 0.0f - x ) - scale ) ) );
}
}

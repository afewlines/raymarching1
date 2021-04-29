#ifndef VECTORMATHS_H
#define VECTORMATHS_H
#include <cmath>

namespace VectorMath {
float min( float x, float y );
float max( float x, float y );
float sminCubic( float a, float b, float k );
float clamp( float x, float min, float max );

float falloff_scale( float x, float scale );
}
#endif

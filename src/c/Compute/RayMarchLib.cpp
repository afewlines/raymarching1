#include "RayMarchLib.h"

using namespace VectorMath;

const vec3 normal_offset_x( NORMALOFF, 0.00f, 0.00f );
const vec3 normal_offset_y( 0.00f, NORMALOFF, 0.00f );
const vec3 normal_offset_z( 0.00f, 0.00f, NORMALOFF );

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
} // clamp2

vec3 get_normal( World *world, vec3 p ) {
	// normal functions are dumb and i hate them

	vec3 normal(
		world->distance_func_fast( p - normal_offset_x, 8.0f ) * -1.0f,
		world->distance_func_fast( p - normal_offset_y, 8.0f ) * -1.0f,
		world->distance_func_fast( p - normal_offset_z, 8.0f ) * -1.0f
		);

	normal += world->distance_func_fast( p, 8.0f );
	return ( normal.normalize() );
} // getNormal

float march_ray_depth( DISTRESULT *dist, World *world, vec3 *ray, float u, float v ) {
	vec3  ray_direction( world->active_camera->get_lookat( u, v ) );
	vec3  ray_origin( *ray );                // where the ray starts (uv offset from camrea)
	vec3  ray_current( 0.0f );               // where the ray currently is
	float dist_origin = world->min_distance; // total distance from origin


	for ( int i = 0; i < world->max_steps; i++ ) {
		ray_current = ray_origin +                  // from the origin, travel as much as we know we can
		    ( ray_direction * dist_origin );        // in the direction we're looking.
		world->distance_func( dist, &ray_current ); // get closest renderable object/signed distance
		dist_origin += dist->d;                     // increase total distance travelled
		if ( ( dist_origin > world->max_distance ) || ( dist->d < world->min_distance ) ) {
			break;                              // if we're too close to an object or out of bounds, we're done.
		}
	}

	ray->set( ray_current ); // update last valid position of ray
	return ( dist_origin );
} // march_ray_depth

float marchy_ray_soft_shadow( World *world, vec3 ray_origin, vec3 ray_direction, float limit, float k ) {
	vec3  ray_current( 0.0f ); // where the ray currently is
	float dist_step, dist_origin = 0.0f, result = 1.0f;

	for ( dist_origin = world->min_distance; dist_origin < limit; ) {
		ray_current = ray_origin +           // from the origin, travel as much as we know we can
		    ( ray_direction * dist_origin ); // in the direction we're looking.
		dist_step = world->distance_func_fast( ray_current, limit );

		result       = min( result, k * dist_step / dist_origin );
		dist_origin += dist_step;            // increase total distance travelled
		if ( dist_step < world->threshold ) {
			return ( 0.0f );             // bonk full shadow
		}
	}

	return ( result );
} // march_ray_depth

float get_light_diffuse( World *world, vec3 pos ) {
	vec3  normal = get_normal( world, pos );
	vec3  light_normal( 0.0f );
	float light_dist, diffuse, shadow, result = 0.0f;

	for ( int i = 0; i < world->lights.size(); ++i ) {
		light_normal.set( world->lights[ i ]->position );
		light_normal -= pos;
		light_dist    = light_normal.magnitude();
		light_normal.normalize();
		diffuse = clamp( dot( normal, light_normal ), 0.0f, 1.0f );
		// result += diffuse;
		shadow  = marchy_ray_soft_shadow( world, pos, light_normal, light_dist, 3.f );
		result += diffuse * shadow;
	}
	return ( result );
} // get_light_diffuse

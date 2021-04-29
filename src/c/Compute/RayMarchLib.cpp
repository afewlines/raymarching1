#include "RayMarchLib.h"

using namespace VectorMath;

const vec3 normal_offset_x( NORMALOFF, 0.00f, 0.00f );
const vec3 normal_offset_y( 0.00f, NORMALOFF, 0.00f );
const vec3 normal_offset_z( 0.00f, 0.00f, NORMALOFF );
const vec3 null_height( 1.0, 0.0, 1.0 );
const vec3 ray_offset( 1.0f, 1.0f, 1.0f );


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

	// vec3  offset( 0.0f );                    // current wiggle offset
	// float t;	                                // wiggle var
	for ( int i = 0; i < world->max_steps; i++ ) {
		// t        = ( null_height * dist_origin ).magnitude() / 50.0f;
		// offset.x = ray_direction.x;
		// offset.y = ray_direction.y - 0.6f;
		// offset.z = ray_direction.z - ( cos( t * 0.5f ) * 0.3f );
		// offset.normalize();
		// ray_current = ( ray_origin ) +              // ray warp integration
		//     ( offset * dist_origin );

		ray_current = ( ray_origin ) +              // from the origin, travel as much as we know we can
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

float marchy_ray_hard_shadow( World *world, vec3 ray_origin, vec3 ray_direction, float limit ) {
	vec3  ray_current( 0.0f ); // where the ray currently is
	float dist_step, dist_origin = 0.0f;

	for ( dist_origin = world->min_distance; dist_origin < limit; ) {
		ray_current = ray_origin +           // from the origin, travel as much as we know we can
		    ( ray_direction * dist_origin ); // in the direction we're looking.
		dist_step = world->distance_func_fast( ray_current, limit );

		dist_origin += dist_step;            // increase total distance travelled
		if ( dist_step < world->threshold ) {
			return ( 0.0f );             // bonk full shadow
		}
	}

	return ( 1.0f );
} // marchy_ray_hard_shadow

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
} // marchy_ray_soft_shadow

float marchy_ray_soft_shadow_improved( World *world, vec3 ray_origin, vec3 ray_direction, float limit, float k ) {
	vec3  ray_current( 0.0f ); // where the ray currently is
	float dist_step, dist_origin = 0.0f, result = 1.0f;
	float y, d, pstep = 1e20;

	for ( dist_origin = world->min_distance; dist_origin < limit; ) {
		ray_current = ray_origin +           // from the origin, travel as much as we know we can
		    ( ray_direction * dist_origin ); // in the direction we're looking.
		dist_step = world->distance_func_fast( ray_current, limit );
		if ( dist_step < world->threshold ) {
			return ( 0.0f );             // bonk full shadow
		}

		y            = ( dist_step * dist_step ) / ( 2.0f * pstep ); // calculate median spot
		d            = sqrt( ( dist_step * dist_step ) - y * y );    // get dist apx at median
		result       = min( result, k * d / max( 0.0f, dist_origin - y ) );
		pstep        = dist_step;
		dist_origin += dist_step;
	}

	return ( result );
} // marchy_ray_soft_shadow

float get_light_diffuse( World *world, vec3 pos ) {
	vec3  normal = get_normal( world, pos );
	vec3  light_normal( 0.0f );
	float light_dist, diffuse, shadow, result = 0.0f;
	int   i;

	for ( i = 0; i < world->lights.size(); ++i ) {
		light_normal.set( world->lights[ i ]->position );
		light_normal -= pos;
		light_dist    = light_normal.magnitude();
		light_normal.normalize();
		diffuse = clamp( dot( normal, light_normal ), 0.0f, 1.0f );
		// shadow  = marchy_ray_hard_shadow( world, pos, light_normal, light_dist );
		// shadow = marchy_ray_soft_shadow( world, pos, light_normal, light_dist, 6.f );
		shadow = marchy_ray_soft_shadow_improved( world, pos, light_normal, light_dist, 4.f );

		result += diffuse * shadow * falloff_scale( light_dist * light_dist, 5.0f );
	}
	return ( result / float (i) );
} // get_light_diffuse

#ifndef RAYMARCHLIB_H
#define RAYMARCHLIB_H
#include "../DataStructures/Color.h"
#include "../DataStructures/Distance.h"
#include "../DataStructures/vec2.h"
#include "../DataStructures/vec3.h"
#include "../Objects/World.h"

#define NORMALOFF 0.01f

float march_ray_depth( DISTRESULT *dist,
                       World *world,
                       VectorMath::vec3 *ray_origin,
                       float u,
                       float v
                       ); //ray dir


float marchy_ray_soft_shadow( World *world,
                              VectorMath::vec3 ray_origin,
                              VectorMath::vec3 ray_direction,
                              float limit,
                              float k
                              );


float get_light_diffuse(World *world,
                        VectorMath::vec3 pos
                        );


VectorMath::vec3 get_normal( World *world,
                             VectorMath::vec3
                             );


#endif

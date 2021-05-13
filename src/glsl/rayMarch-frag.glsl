
#define MAX_GEOMETRY_COUNT 100

/* This is how I'm packing the data
struct geometry_t {
    vec3 position;
    float type;
};
*/

float dot2(in vec2 v) { return dot(v, v); }
float dot2(in vec3 v) { return dot(v, v); }
float ndot(in vec2 a, in vec2 b) { return a.x * b.x - a.y * b.y; }

uniform vec4 u_buffer[MAX_GEOMETRY_COUNT];
uniform int u_count;

varying vec2 f_uv;

/**
 * Sphere
 */
float SphereSDF(vec3 pos, float radius, vec3 center) {
    return length(pos - center) - radius;
}

/**
 * Box
 */
float BoxSDF(vec3 pos, vec3 extent, vec3 center) {
    vec3 dist = abs(pos - center) - extent;
    return length(max(dist, 0.0) + min(max(dist.x, max(dist.y, dist.z)), 0));
}

/**
 * Cone
 */
float ConeSDF(vec3 pos, vec3 center, float radius, float height) {

}

int MAX_ATTEPT = 10;
float GetShortestDistanceToSurface(vec3 eye, vec3 direction, float start, float end) {
    float dist = start;
    for (int i = 0; i < MAX_ATTEPT; i++)
    {
        float dis = SphereSDF(eye + direction * dist);
        if (dis < EPSILON) {
            return dis;
        }
        dist += dis;
        if (dist >= end) {
            return end;
        }
    }

    return end;
}

vec3 GetRayDirection() {
    return normalize(gl_Position);
}

float Min_Dist = 0;
float Max_Dist = 100;

vec4 PhongShading()
{
    return vec4(0, 1, 1, 1);
}

void main() {
    vec3 rayDir = GetRayDirection();
    vec3 eye;
    eye.xyz = 0;
    vec4 color;

    float t;
    for (int i = 0; i < MAX_GEOMETRY_COUNT; ++i) {
        if (i >= u_count) {
            break;
        }

        float distance = GetShortestDistanceToSurface(eye, direction, Min_Dist, Max_Dist);
        if (distance >= Max_Dist - EPSILON)
        {
            color = vec4(0, 0, 0, 0);        
        }
        else
        {
            color = PhongShading();
        }
    }
    gl_FragColor = color;
    // gl_FragColor = vec4(f_uv, 0, 1);
}
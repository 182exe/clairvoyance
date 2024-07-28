#version 120

#define Chams //[true false]
#define Chams_targets 1 //[1 2]

varying vec2 lmcoord;
varying vec2 texcoord;

attribute float mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform int entityId;

varying vec4 color;
varying vec4 colorLightless;

void main() {
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos, 1)).xyz;

    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(pos, 1);
    gl_FogFragCoord = length(pos);

    vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = (gbufferModelViewInverse * vec4(normal, 0)).xyz;
    
    // vanilla lighting (@peppercode1, adjusted)
    float light = min(normal.x * normal.x * 0.6 + normal.y * normal.y * 0.25 * (3 + normal.y) + normal.z * normal.z * 0.8, 1);

    color = vec4(gl_Color.rgb * light, gl_Color.a);
    colorLightless = vec4(gl_Color.rgb, gl_Color.a);

    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    #ifdef Chams // todo: make system for this better, like it is for xray
        if (entityId != 1100 || Chams_targets == 1) {
            gl_Position.z = 0.001 * gl_Position.w + 0.1 * gl_Position.z;
        }
    #endif
}

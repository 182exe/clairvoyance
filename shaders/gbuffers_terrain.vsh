#version 120

#define Xray //[true false]
#define Xray_obsidian //[true false]
#define Xray_ore //[true false]
#define Xray_bed //[true false]

attribute float mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

uniform int entityId;

varying vec4 color;
varying vec4 colorLightless;
varying vec2 coord0;
varying vec2 coord1;
varying float id;

void main()
{
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos,1)).xyz;

    vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = (mc_Entity == 1) ? vec3(0, 1, 0) : (gbufferModelViewInverse * vec4(normal, 0)).xyz;

    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(pos,1);
    gl_FogFragCoord = length(pos);

    // vanilla lighting (@peppercode1, adjusted)
    float light = min(normal.x * normal.x * 0.6 + normal.y * normal.y * 0.25 * (3 + normal.y) + normal.z * normal.z * 0.8, 1);

    color = vec4(gl_Color.rgb * light, gl_Color.a);
    colorLightless = vec4(gl_Color.rgb, gl_Color.a);

    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    id = mc_Entity;

    #ifdef Xray
        #ifdef Xray_obsidian
            if (mc_Entity == 4000) {
                gl_Position.z = min(gl_Position.z, 0.001 * gl_Position.w + 0.01 * gl_Position.z);
            }
        #endif
        #ifdef Xray_bed
            if (mc_Entity == 5000) {
                gl_Position.z = 0.001 * gl_Position.w + 0.01 * gl_Position.z;
            }
        #endif
        #ifdef Xray_ore
            if (mc_Entity == 6000) {
                gl_Position.z = 0.001 * gl_Position.w + 0.01 * gl_Position.z;
            }
        #endif
    #endif
}
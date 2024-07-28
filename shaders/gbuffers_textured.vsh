//Declare GL version.
#version 120

#define Tags //[true false]

attribute float mc_Entity;

uniform sampler2D texture;
uniform sampler2D gaux4;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

varying vec4 color;
varying vec4 colorLightless;
varying vec2 coord0;
varying vec2 coord1;

void main()
{
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos, 1)).xyz;

    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(pos, 1);
    gl_FogFragCoord = length(pos);

    vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
    normal = (gbufferModelViewInverse * vec4(normal, 0)).xyz;
    
    // vanilla lighting (@peppercode1, adjusted)
    float light = min(normal.x * normal.x * 0.6 + normal.y * normal.y * 0.25 * (3.0 + normal.y) + normal.z * normal.z * 0.8, 1.0);

    color = vec4(gl_Color.rgb, gl_Color.a);
    colorLightless = vec4(gl_Color.rgb, gl_Color.a);

    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    
    #ifdef Tags
        // masks out text boxes, and compares them to this
        if (texture2D(gaux4, gl_TexCoord[0].xy).rgb == vec3(1.0, 0.0, 0.0)) {
            gl_Position.z = 0.001 * gl_Position.w + 0.1 * gl_Position.z;
        }
        
        // semitransparent background is preserved (probably)
        if (
            gl_Color.a > 0.0
            && any(greaterThan(gl_Color.rgb, vec3(0.0)))
        ) {
            color.a = 1.0;
            colorLightless.a = 1.0;
        }
    #endif
}

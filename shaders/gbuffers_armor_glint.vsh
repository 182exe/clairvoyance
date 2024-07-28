#version 120

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

varying vec4 color;
varying vec2 coord0;

void main()
{
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos, 1)).xyz;

    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(pos, 1);
    gl_FogFragCoord = length(pos);

    vec3 normal = vec3(0, 1, 0); // armor glint is always bright

    color = vec4(gl_Color.rgb, gl_Color.a);
    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

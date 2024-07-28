#version 120

uniform sampler2D texture;

uniform vec4 entityColor;

varying vec4 color;
varying vec4 colorLightless;

varying vec2 coord0;

void main() {
    vec4 texColor = texture2D(texture, coord0);

    vec4 col = colorLightless * texColor;

    col.rgb = mix(col.rgb, entityColor.rgb, entityColor.a);
    gl_FragData[0] = col;
}
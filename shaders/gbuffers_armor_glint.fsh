#version 120

uniform sampler2D texture;

varying vec4 color;
varying vec2 coord0;

void main() {
    gl_FragData[0] = texture2D(texture, coord0) * color;
}
#version 120

// the decorative options are declared here just so they show up in the shader options menu
#define Mark 0 //[0 1 2 3 4 5 6 7 8 9 10 11]
#define Blank 0 //[0 1]

varying vec4 color;

void main()
{
    gl_FragData[0] = color;
}

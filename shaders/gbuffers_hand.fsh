#version 120

#define Tags //[true false]
#define Chams //[true false]
#define Chams_r 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Chams_g 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Chams_b 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Chams_a 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Chams_targets 1 //[1 2]
#define Chams_hand //[true false]
#define Chams_rainbow //[true false]
#define Chams_rainbowspeed 10 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]

uniform sampler2D texture;
uniform vec4 entityColor;
uniform float frameTimeCounter; // accumulated frame time in seconds (is there a better way to do this?)

varying vec2 texcoord;
varying vec4 color;

// rgb/hsv conversions (ai generated lol)
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec4 texColor = texture2D(texture, texcoord);

    vec4 col = color * texColor;

    col.rgb = mix(col.rgb, entityColor.rgb, entityColor.a);

    #ifdef Chams_hand
        #ifdef Chams
            vec4 chamCol = vec4(Chams_r, Chams_g, Chams_b, Chams_a);
            #ifdef Chams_rainbow
                vec3 hsv = rgb2hsv(chamCol.rgb);
                
                // time adjusted hue shift, fps shouldn't affect speed
                float speedFactor = float(Chams_rainbowspeed) / 20.0;
                float hueShiftAmount = mod(frameTimeCounter * speedFactor, 1.0);
                hsv.x = mod(hsv.x + hueShiftAmount, 1.0);
                chamCol.rgb = hsv2rgb(hsv);
            #endif
    
            col = vec4(mix(col.rgb, chamCol.rgb, chamCol.a), col.a);
        #endif
    #endif

    gl_FragData[0] = col;
}
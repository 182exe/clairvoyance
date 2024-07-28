//Declare GL version.
#version 120

#define Xray //[true false]
#define Xray_r 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Xray_g 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Xray_b 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Xray_a 1.00 //[0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define Xray_storage //[true false]
#define Xray_rainbow //[true false]
#define Xray_rainbowspeed 10 //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]

uniform sampler2D texture;

uniform float frameTimeCounter;

varying vec4 color;
varying vec2 coord0;
varying float id;

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
    vec4 texColor = texture2D(texture, coord0);
    vec4 col = color * texColor;
    gl_FragData[0] = col;
    
    #ifdef Xray
        bool highlight = false;

        #ifdef Xray_storage
            if (id == 3000) { highlight = true; }
        #endif

        if (highlight == true) {
            vec4 xrayCol = vec4(Xray_r, Xray_g, Xray_b, Xray_a);
            
            #ifdef Xray_rainbow
                vec3 hsv = rgb2hsv(xrayCol.rgb);
                
                // time adjusted hue shift, fps shouldn't affect speed
                float speedFactor = float(Xray_rainbowspeed) / 20.0;
                float hueShiftAmount = mod(frameTimeCounter * speedFactor, 1.0);
                hsv.x = mod(hsv.x + hueShiftAmount, 1.0);

                xrayCol.rgb = hsv2rgb(hsv);
            #endif

            col = vec4(mix(col.rgb, xrayCol.rgb, xrayCol.a), col.a);
            gl_FragData[0] = col;
        }
    #endif
}
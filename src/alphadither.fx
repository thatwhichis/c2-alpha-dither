// C2 DEFAULT VARIABLES
precision mediump float;
varying mediump vec2 vTex; 
uniform lowp sampler2D samplerFront;

// CUSTOM VARIABLES
uniform lowp float f_dither;
uniform highp float f_scale;
lowp int i_pattern;

// DEPRECATED - LEAVING IN PLACE TO AVOID PLUGIN REGRESSION
uniform lowp float f_sample;

// ALPHA PATTERN MATRICES
mat4 m4_ptn1 = mat4(0.0, 0.0, 0.0, 0.0,
                    0.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    1.0, 0.0, 0.0, 0.0);

mat4 m4_ptn2 = mat4(1.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 0.0,
                    1.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 0.0);

mat4 m4_ptn3 = mat4(0.0, 0.0, 1.0, 0.0,
                    0.0, 1.0, 0.0, 1.0,
                    1.0, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 1.0);

mat4 m4_ptn5 = mat4(1.0, 1.0, 0.0, 1.0,
                    1.0, 0.0, 1.0, 0.0,
                    0.0, 1.0, 1.0, 1.0,
                    1.0, 0.0, 1.0, 0.0);

mat4 m4_ptn6 = mat4(0.0, 1.0, 0.0, 1.0,
                    1.0, 1.0, 1.0, 1.0,
                    0.0, 1.0, 0.0, 1.0,
                    1.0, 1.0, 1.0, 1.0);

mat4 m4_ptn7 = mat4(1.0, 1.0, 1.0, 1.0,
                    1.0, 1.0, 0.0, 1.0,
                    1.0, 1.0, 1.0, 1.0,
                    0.0, 1.0, 1.0, 1.0);

// SYSTEM METHOD
void main(void) {

	// GRAB PIXEL INFO
	lowp vec4 v4_pixel = texture2D(samplerFront, vTex);

	// SCALE COMES THROUGH AS A PERCENTAGE (0.00 - 1.00) - REQUESTED USE-CASE
	highp float f_scaled = f_scale * 100.0;

	// CHEAT - CREATES SCALED VIRTUAL PIXELS FROM SCALE VALUE AT PIXEL XY IN WINDOW SPACE
	lowp int i_x = int(mod((gl_FragCoord.x / f_scaled), 4.0));
	lowp int i_y = int(mod((gl_FragCoord.y / f_scaled), 4.0));

	// SET PATTERN BASED ENTIRELY ON DITHER VALUE - REQUESTED USE-CASE
	i_pattern = int(floor((f_dither * 100.0 / 12.5) + 0.5));
	
	// ASSUME POSITIVE ALPHA
	lowp float f_a = 1.0;

	// MATRIX ACCESSORS HAVE TO BE CONSTANTS; LOOP ITERATORS READ AS CONSTANTS
	// LOOPS CAN BE UNROLLED MANUALLY IF ISSUES PRESENT ON SOME CARDS
	for (int i = 0; i < 4; i++) {		
		if (i_x == i) {
			for (int j = 0; j < 4; j++) {
				if (i_y == j) {
					if (i_pattern == 0) { f_a = 0.0; }
					if (i_pattern == 1) { f_a = m4_ptn1[i][j]; }
					if (i_pattern == 2) { f_a = m4_ptn2[i][j]; }
					if (i_pattern == 3) { f_a = m4_ptn3[i][j]; }
					if (i_pattern == 4) { f_a = abs(((mod(float(i), 2.0)) - (mod(float(j), 2.0)))); }
					if (i_pattern == 5) { f_a = m4_ptn5[i][j]; }
					if (i_pattern == 6) { f_a = m4_ptn6[i][j]; }
					if (i_pattern == 7) { f_a = m4_ptn7[i][j]; }
					break;
				}
			}
		}
	}

	// PIXEL EITHER SET TO 0 BY PATTERN OR RETAINS INITIAL VALUE
	v4_pixel *= f_a;

	// OUTPUT PIXEL INFO
	gl_FragColor = v4_pixel;
}

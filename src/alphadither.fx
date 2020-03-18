// C2 DEFAULT VARIABLES
precision mediump float;
varying mediump vec2 vTex;
uniform lowp sampler2D samplerFront;

// CUSTOM VARIABLES
uniform lowp float f_dither;
uniform lowp float f_scale;

// DEPRECATED - LEAVING IN PLACE TO AVOID PLUGIN REGRESSION
uniform lowp float f_sample;

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

mat4 m4_ptn4 = mat4(1.0, 0.0, 1.0, 0.0,
					0.0, 1.0, 0.0, 1.0,
					1.0, 0.0, 1.0, 0.0,
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
	vec4 v4_scaled = vec4(f_scale * 100.0);

	// CHEAT - CREATES SCALED VIRTUAL PIXELS FROM SCALE VALUE AT PIXEL XY IN WINDOW SPACE
	// V4_X USED AS MATRIX MULTIPLIER TO REMOVE MATRIX ACCESSOR
	lowp vec4 v4_x = step(vec4(3.0, 3.0, 3.0, 3.0), mod((gl_FragCoord.xxxx / v4_scaled + vec4(3.0, 0.0, 1.0, 2.0)), vec4(4.0, 4.0, 4.0, 4.0)));
	// I_Y USED AS V4_X ACCESSOR
	lowp int i_y = int(mod((gl_FragCoord.y / v4_scaled.y), 4.0));

	// SET PATTERN BASED ENTIRELY ON DITHER VALUE - REQUESTED USE-CASE
	lowp int i_pattern = int(floor((f_dither * 100.0 / 12.5) + 0.5));

	// ASSUME POSITIVE ALPHA
	lowp float f_a = 1.0;

	// SET V4_X BASED ON PATTERN
	if (i_pattern == 0) { v4_x = vec4(0.0); }
	if (i_pattern == 1) { v4_x *= m4_ptn1; }
	if (i_pattern == 2) { v4_x *= m4_ptn2; }
	if (i_pattern == 3) { v4_x *= m4_ptn3; }
	if (i_pattern == 4) { v4_x *= m4_ptn4; }
	if (i_pattern == 5) { v4_x *= m4_ptn5; }
	if (i_pattern == 6) { v4_x *= m4_ptn6; }
	if (i_pattern == 7) { v4_x *= m4_ptn7; }
	if (i_pattern == 8) { v4_x = vec4(1.0); }

	// VECTOR ACCESSORS HAVE TO BE CONSTANTS; LOOP ITERATORS READ AS CONSTANTS
	// LOOP CAN BE UNROLLED MANUALLY IF ISSUES PRESENT ON SOME CARDS
	for (int i = 0; i < 4; i++) {
		if (i_y == i) {
			f_a = v4_x[i];
			break;
		}
	}

	// PIXEL EITHER SET TO 0 BY PATTERN OR RETAINS INITIAL VALUE
	v4_pixel *= f_a;

	// OUTPUT PIXEL INFO
	gl_FragColor = v4_pixel;
}

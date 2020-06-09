
/* center radius (pixels) */
#define C_RADIUS 128
/* center line thickness (pixels) */
#define C_LINE 5
/* outline color */
#define OUTLINE {color4}
/* number of bars (use even values for best results) */
#define NBARS 180
/* width (in pixels) of each bar*/
#define BAR_WIDTH 4.5
/* outline color */
#define BAR_OUTLINE OUTLINE
/* outline width (in pixels, set to 0 to disable outline drawing) */
#define BAR_OUTLINE_WIDTH 0
/* Amplify magnitude of the results each bar displays */
#define AMPLIFY 500
/* Bar color */ 
#define COLOR ({color4}* ((d / 200) + 1))
/* Angle (in radians) for how much to rotate the visualizer */
#define ROTATE (PI / 2)
/* Whether to switch left/right audio buffers */
#define INVERT 0
/* Aliasing factors. Higher values mean more defined and jagged lines.
   Note: aliasing does not have a notable impact on performance, but requires
   `xroot` transparency to be enabled since it relies on alpha blending with
   the background. */
/* originally 1.2 and 1.8 */
#define BAR_ALIAS_FACTOR 0.8
#define C_ALIAS_FACTOR 1.0
/* Offset (Y) of the visualization */
#define CENTER_OFFSET_Y 0
/* Offset (X) of the visualization */
#define CENTER_OFFSET_X 0

/* Gravity step, override from `smooth_parameters.glsl` */
#request setgravitystep 5.0

/* Smoothing factor, override from `smooth_parameters.glsl` */
#request setsmoothfactor 0.04
// vim:ft=c

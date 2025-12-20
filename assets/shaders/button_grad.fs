#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

#define MAX_GRAD_POINTS 8

extern MY_HIGHP_OR_MEDIUMP float start_x = 0;
extern MY_HIGHP_OR_MEDIUMP float end_x = 100;
extern int grad_size = 1;
extern MY_HIGHP_OR_MEDIUMP vec4 grad_points[MAX_GRAD_POINTS];

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	float uv = (screen_coords.x - start_x) / (end_x - start_x);
	vec4 base_colour = vec4(grad_points[0].r, grad_points[0].g, grad_points[0].b, 1);
	if (grad_size > 1) {
		for (int i = 0; i < grad_size-1; i++) {
			if (uv <= grad_points[i+1].a) {
				uv = (uv - grad_points[i].a) / (grad_points[i+1].a - grad_points[i].a);
				base_colour.r = grad_points[i].r + uv * (grad_points[i+1].r - grad_points[i].r);
				base_colour.g = grad_points[i].g + uv * (grad_points[i+1].g - grad_points[i].g);
				base_colour.b = grad_points[i].b + uv * (grad_points[i+1].b - grad_points[i].b);
				return base_colour;
			}
		}
	}

	return base_colour;
}
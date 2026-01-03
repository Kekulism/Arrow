#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern MY_HIGHP_OR_MEDIUMP vec4 outline_color;
extern MY_HIGHP_OR_MEDIUMP vec2 step_size;

#define PI 3.1415926535897932384626433832795

float atan2(float y, float x) {
    if (x == 0.0) {
        return mod(atan(y,0.01) + PI, PI *2);
    }
    return mod(atan(y,x) + PI, PI * 2);
}

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
	vec4 ret = Texel(tex, tex_coords);
    vec2 uv = ((tex_coords*image_details) - texture_details.xy*texture_details.ba)/texture_details.ba;

    float x_scale = texture_details.b/image_details.x;
    float y_scale = texture_details.a/image_details.y;
    float local_x_origin = x_scale*texture_details.x;
    float local_y_origin = y_scale*texture_details.y;

    float norm_x = ((tex_coords.x - local_x_origin)/x_scale - 0.5) * 2;
    float norm_y = ((tex_coords.y - local_y_origin)/y_scale - 0.5) * -2;

    float comp_angle = mod(time * 0.75, 1) * PI * 2;
    float theta = atan2(norm_y, norm_x);
    float inverse_theta = atan2(-norm_y, -norm_x);

    float outer_alpha = 4 * ret.a;
    float x_step = step_size.x / image_details.x;
    float y_step = step_size.y / image_details.y;
    outer_alpha -= Texel(tex, tex_coords + vec2(x_step, 0.0)).a;
    outer_alpha -= Texel(tex, tex_coords + vec2(-x_step, 0.0)).a;
    outer_alpha -= Texel(tex, tex_coords + vec2(0.0, y_step)).a;
    outer_alpha -= Texel(tex, tex_coords + vec2(0.0, -y_step)).a;

    vec4 ret_color = vec4(outline_color.rgb, min(outer_alpha, ret.a));
    if (ret_color.a == 0 && ret.a > 0) {
        float inner_alpha = 4 * ret.a;
        float x_step = (step_size.x + 2) / image_details.x;
        float y_step = (step_size.y + 2) / image_details.y;
        inner_alpha -= Texel(tex, tex_coords + vec2(x_step, 0.0)).a;
        inner_alpha -= Texel(tex, tex_coords + vec2(-x_step, 0.0)).a;
        inner_alpha -= Texel(tex, tex_coords + vec2(0.0, y_step)).a;
        inner_alpha -= Texel(tex, tex_coords + vec2(0.0, -y_step)).a;

        if (inner_alpha > 0) {
            ret_color = vec4(1.0);
        }
    }

    float diff = abs(mod(comp_angle - theta, 2 * PI));
    float offset_diff = abs(mod(comp_angle - inverse_theta, 2 * PI));
    if (diff < 1.571 || offset_diff < 1.1) {
        ret_color.a = 0.;
    }

	return ret_color;
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    MY_HIGHP_OR_MEDIUMP float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    MY_HIGHP_OR_MEDIUMP vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    MY_HIGHP_OR_MEDIUMP float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif
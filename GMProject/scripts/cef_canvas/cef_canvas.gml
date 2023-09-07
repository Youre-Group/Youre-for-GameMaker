function cef_canvas() constructor {
	x = 0;
	y = 0;
	image_angle = 0;
	image_xscale = 1;
	image_yscale = 1;
	image_blend = c_white;
	image_alpha = 1.0;
	is_gui = false;
	static update = function() {
		var _ox = (is_gui ? device_mouse_x_to_gui(0) : mouse_x) - x;
		var _oy = (is_gui ? device_mouse_y_to_gui(0) : mouse_y) - y;
		var _cos = dcos(image_angle);
		var _sin = dsin(image_angle);
		var _lx = _cos * _ox - _sin * _oy;
		var _ly = _sin * _ox + _cos * _oy;
		_lx /= image_xscale;
		_ly /= image_yscale;
		cef_update(_lx, _ly);
	}
	static draw_now = function() {
		if(!surface_exists(cef_surface)){
			return;
		}
		shader_set(sh_cef_bgr);
		draw_surface_ext(cef_surface, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		shader_reset();
	}
}
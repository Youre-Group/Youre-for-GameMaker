#define cef_preinit
//#init cef_preinit
//#macro cef_surface global.__cef_surf
global.__cef_rgba = undefined;
global.__cef_surf = undefined;
global.__cef_width = 1;
global.__cef_height = 1;

#define cef_init
/// (width, height, url)
var _width = argument0, _height = argument1, _url = argument2;
var _result = cef_init_raw(_width, _height, window_handle(), _url);
if (_result < 1) return _result;
cef_set_size(_width, _height);
return _result;

#define cef_get_width
/// ()->
return global.__cef_width;

#define cef_get_height
/// ()->
return global.__cef_height;

#define cef_set_size
/// (width, height)
var _width = argument0, _height = argument1;
if (_width <= 0 || _height <= 0) show_error("Width/height cannot be 0 or lower", true);
var _size = _width * _height * 4;
global.__cef_width = _width;
global.__cef_height = _height;

var _rgba = global.__cef_rgba;
if (_rgba == undefined) {
	_rgba = buffer_create(_size, buffer_fixed, 1);
	global.__cef_surf = -1;
	global.__cef_rgba = _rgba;
} else {
	buffer_resize(_rgba, _size);
	var _surf = global.__cef_surf;
	if (surface_exists(_surf)) surface_resize(_surf, _width, _height);
}
buffer_set_used_size(_rgba, _size);

return cef_set_size_raw(_width, _height, buffer_get_address(_rgba));

#define cef_update
/// (rel_mouse_x, rel_mouse_y, canmouseover = true)
var _mx = argument[0], _my = argument[1];
var _canmouseover = argument_count > 2 ? argument[2] : true;
if (keyboard_check_released(vk_shift))      cef_mouse_flag(4, false);
if (keyboard_check_released(vk_control))    cef_mouse_flag(8, false);
if (mouse_check_button_released(mb_left))   cef_mouse_event(-1, current_time);
if (mouse_check_button_released(mb_right))  cef_mouse_event(-2, current_time);
if (mouse_check_button_released(mb_middle)) cef_mouse_event(-3, current_time);
cef_mouse_move(_mx, _my, current_time, _canmouseover);
if (keyboard_check_pressed(vk_shift))      cef_mouse_flag(4, true);
if (keyboard_check_pressed(vk_control))    cef_mouse_flag(8, true);
if (mouse_check_button_pressed(mb_left))   cef_mouse_event(1, current_time);
if (mouse_check_button_pressed(mb_right))  cef_mouse_event(2, current_time);
if (mouse_check_button_pressed(mb_middle)) cef_mouse_event(3, current_time);

if (!cef_update_raw()) exit;

var _surf = global.__cef_surf;
if (_surf == undefined || !surface_exists(_surf)) {
	_surf = surface_create(global.__cef_width, global.__cef_height);
	global.__cef_surf = _surf;
} else if (
	surface_get_width(_surf) != global.__cef_width ||
	surface_get_height(_surf) != global.__cef_height
) {
	surface_resize(_surf, global.__cef_width, global.__cef_height);
}
if (cef_needs_redraw()) {
	buffer_set_surface(global.__cef_rgba, _surf, 0);
}

#define cef_prepare_buffer
/// (size:int)->buffer~
var _size = argument0;
gml_pragma("global", "global.__cef_buffer = undefined");
var _buf = global.__cef_buffer;
if (_buf == undefined) {
    _buf = buffer_create(_size, buffer_grow, 1);
    global.__cef_buffer = _buf;
} else if (buffer_get_size(_buf) < _size) {
    buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;
#define cef_mouse_flag
/// cef_mouse_flag(rawFlag:int, enable:int)
var _buf = cef_prepare_buffer(8);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
cef_mouse_flag_raw(buffer_get_address(_buf), 8);

#define cef_mouse_event
/// cef_mouse_event(kind:int, time:int)->bool
var _buf = cef_prepare_buffer(8);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
return cef_mouse_event_raw(buffer_get_address(_buf), 8);

#define cef_mouse_move
/// cef_mouse_move(nx:int, ny:int, time:int, canmouseover:bool)->bool
var _buf = cef_prepare_buffer(13);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_bool, argument3);
return cef_mouse_move_raw(buffer_get_address(_buf), 13);


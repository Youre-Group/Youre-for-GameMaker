if(os_type == os_windows && variable_instance_exists(self,"_canvas") && _update_windows_cef)
{
	_canvas.update();
	_check_url(cef_get_address());
}


if(os_type == os_android)
{
	var _url = WebView_Get_Address();
	_check_url(_url);
}
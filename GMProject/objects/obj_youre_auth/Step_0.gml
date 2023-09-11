if(os_type == os_windows && variable_instance_exists(self,"_canvas") && _update_webview)
{
	_canvas.update();
	_check_url(cef_get_address());
}

if((os_type == os_android || os_type == os_android) && _update_webview)
{
	var _url = WebView_Get_Address();
	_check_url(_url);
}
if ds_map_find_value(async_load, "type") == "youre_challenge_generator"
{
	var _challenge = ds_map_find_value(async_load, "challenge");
	on_code_challenge_created(_challenge);
}

if ds_map_find_value(async_load, "type") == "WebView"
{
	if ds_map_find_value(async_load, "event") == "onAddressChange"
	{
		var _authResponseUrl = ds_map_find_value(async_load, "url");
		_check_url(_authResponseUrl);
	}
}

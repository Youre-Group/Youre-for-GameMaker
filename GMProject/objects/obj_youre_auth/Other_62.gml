if (ds_map_find_value(async_load,"id") == _request_token_id)
{
	if ds_map_find_value(async_load, "status") == 0
	{
	    var _result_str = ds_map_find_value(async_load, "result");
		var _result = json_decode(_result_str);
		if ( _result[?"access_token"] != undefined && _result[?"access_token"] != "") 
		{
			_on_tokendata_received(_result);
		}
	}
} 
else if (ds_map_find_value(async_load,"id") == _request_userinfo_id)
{
	if ds_map_find_value(async_load, "status") == 0
	{
	    var _result_str = ds_map_find_value(async_load, "result");
		var _result = json_decode(_result_str);
		if ( _result[?"sub"] != undefined && _result[?"sub"] != "") 
		{
			_on_userinfo_received(_result);
		}
		else 
		{
			show_debug_message(_result_str);
			_on_request_userinfo_failed();
		}
	} 
	else 
	{
		_on_request_userinfo_failed();
	}
}

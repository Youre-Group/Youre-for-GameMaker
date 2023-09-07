_state = 1;
_pkce = new PKCEHelper();
_redirect_url = "unity:oauth";
_request_token_id = -1;
_request_userinfo_id = -1;

endpoint = "";
client_id = "";
width = 0;
height = 0;

function logout()
{
	if(endpoint == "")
	{
		show_debug_message("You have to call .init before using any service");
		return;
	}
	
	var _cache = new SessionCache();
	_cache.clear();
	//client_id={client_id}&
	// does global logout for nowv
	var _logout_request_url = $"https://{endpoint}/v2/logout?returnTo={url_encode("https://youre.games")}";
	http_request(_logout_request_url,"GET", ds_map_create(),"");
}

function close()
{
	_state = 1;
	if(os_type == os_android)
	{
		WebView_Destroy();
	}
}



function _check_url(_url)
{
	if(_state ==1)
	{
		return;
	}
	if(string_starts_with(_url,_redirect_url)){
		
		if(os_type == os_android)
		{
			WebView_Destroy();
		}

		var _auth_code = "";
		_auth_code = string_replace(_url,_redirect_url+"?code=","");
		_auth_code = string_replace(_auth_code,_redirect_url+"/?code=","");
		
		_state = 1;
		
		var _token_request_url = $"https://{endpoint}/oauth/token";
		var _data = $"grant_type=authorization_code";
		_data += $"&client_id={client_id}";
		_data += $"&redirect_uri={_redirect_url}";
		_data += $"&code={_auth_code}";
		_data += $"&code_verifier={_pkce.code_verifier}";
		_data += "&token_endpoint_auth_method=none";

		var _header = ds_map_create();
		ds_map_add(_header,"content-type","application/x-www-form-urlencoded");

		_request_token_id = http_request(_token_request_url,"POST",_header, _data);
	}
}

function _on_userinfo_received(_userinfo_data)
{
	var _sub_split = string_split_ext(_userinfo_data[?"sub"], ["|"]);
	success_callback(_sub_split[1],_userinfo_data);
}

function _on_tokendata_received(_token_data)
{
	var _cache = new SessionCache();
	_cache.save_json(_token_data);
	_request_userinfo(_token_data[?"access_token"]);
}

function _request_userinfo(_access_token)
{
	var _userinfo_request_url = $"https://{endpoint}/oauth2/userInfo";
	var _header = ds_map_create();
	ds_map_add(_header,"Authorization", "Bearer "+_access_token);
	_request_userinfo_id = http_request(_userinfo_request_url,"GET", _header,"");
}

function _on_request_userinfo_failed()
{
	var _cache = new SessionCache();
	_cache.clear();
	authenticate(width, height, success_callback);
}

function init(_endpoint, _client_id)
{
	endpoint = _endpoint;
	client_id = _client_id;
}

function authenticate(_width, _height, _on_success_callback) 
{
	if(endpoint == ""){
		show_debug_message("You have to call .init before using any service");
		return;
	}
	width = _width;
	height = _height;
	success_callback = _on_success_callback;
	
	show_debug_message("Starting YOURE Authentication...");

	// Try load session from cache
	var _cache = new SessionCache();
	var _session = _cache.load();
	if(_session != undefined && _session[?"access_token"] != undefined)
	{
		_request_userinfo(_session[?"access_token"]);
		return;
	}
	
	 var _url = $"https://{_endpoint}/authorize?";
        _url += $"client_id={_client_id}";
        _url += $"&redirect_uri={_redirect_url}";
        _url += "&response_type=code";
        _url += "&token_endpoint_auth_method=none";
        _url += "&scope=openid%20email%20profile";
        _url += $"&code_challenge={_pkce.code_challenge}";
        _url += "&code_challenge_method=S256";
	
	if(os_type == os_windows)
	{
		cef_init(_width, _height, _url);
		cef_set_focus(true);
	
		_canvas = new cef_canvas();
		_canvas.x = window_get_width()/2-_width*0.5;
		_canvas.y = window_get_height()/2-_height*0.5;
	} 
	else if(os_type == os_android)
	{
		WebView_Create(_url);
	}
	
	_state = 0;
}











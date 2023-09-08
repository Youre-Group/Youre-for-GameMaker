_update_windows_cef = false;

_request_token_id = -1;
_request_userinfo_id = -1;


redirect_url = "unity:oauth";
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
	
	ini_open("youre.cache");
	ini_write_string("session", "access_token", "");
	ini_close();
	
	//client_id={client_id}&
	// does global logout for nowv
	var _logout_request_url = $"https://{endpoint}/v2/logout?returnTo={url_encode("https://youre.games")}";
	http_request(_logout_request_url,"GET", ds_map_create(),"");
}

function close()
{
	if(os_type == os_windows && os_browser == browser_not_a_browser)
	{
		_update_windows_cef = false;
	}

	if(os_type == os_android)
	{
		WebView_Destroy();
	}
}


function _request_token(_auth_code)
{
	var _token_request_url = $"https://{endpoint}/oauth/token";
	var _data = $"grant_type=authorization_code";
	_data += $"&client_id={client_id}";
	_data += $"&redirect_uri={url_encode(redirect_url)}";
	_data += $"&code={_auth_code}";
	_data += $"&code_verifier={_pkce.code_verifier}";
	_data += "&token_endpoint_auth_method=none";

	var _header = ds_map_create();
	ds_map_add(_header,"content-type","application/x-www-form-urlencoded");

	_request_token_id = http_request(_token_request_url,"POST",_header, _data);
}

function _check_url(_url)
{
	if(os_type == os_windows && os_browser == browser_not_a_browser && !_update_windows_cef)
	{
		return;
	}
	
	if(string_starts_with(_url,redirect_url)){
		
		if(os_type == os_android)
		{
			WebView_Destroy();
		}
		
		if(os_type == os_windows && os_browser == browser_not_a_browser)
		{
			_update_windows_cef = false;
		}

		var _auth_code = "";
		_auth_code = string_replace(_url,redirect_url+"?code=","");
		_auth_code = string_replace(_auth_code,redirect_url+"/?code=","");
		_auth_code = string_split(_auth_code,"&")[0];
		
		_request_token(_auth_code);
	}
}

function _on_userinfo_received(_userinfo_data)
{
	var _sub_split = string_split_ext(_userinfo_data[?"sub"], ["|"]);
	success_callback(_sub_split[1],_userinfo_data);
}

function _on_tokendata_received(_token_data)
{
	
	ini_open("youre.cache");
	ini_write_string("session", "access_token",_token_data[?"access_token"]);
	ini_close();
	
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

function init(_endpoint, _client_id, _custom_redirect_url = undefined)
{
	_pkce = new PKCEHelper();
	endpoint = _endpoint;
	client_id = _client_id;
	if(_custom_redirect_url == undefined && os_browser != browser_not_a_browser)
	{
		redirect_url = get_current_url();
	} 
	else if (_custom_redirect_url != undefined)
	{
		redirect_url = _custom_redirect_url;
	}

}



function _show_login()
{
	 var _url = $"https://{endpoint}/authorize?";
        _url += $"client_id={client_id}";
        _url += $"&redirect_uri={url_encode(redirect_url)}";
        _url += "&response_type=code";
        _url += "&token_endpoint_auth_method=none";
        _url += "&scope=openid%20email%20profile";
        _url += $"&code_challenge={_pkce.code_challenge}";
        _url += "&code_challenge_method=S256";
	
	if(os_type == os_windows && os_browser == browser_not_a_browser)
	{
		cef_init(width, height, _url);
		cef_set_focus(true);
	
		_canvas = new cef_canvas();
		_canvas.x = window_get_width()/2-width*0.5;
		_canvas.y = window_get_height()/2-height*0.5;
		_update_windows_cef = true;
	} 
	else if(os_type == os_android)
	{
		WebView_Create(_url);
	}
	else if(os_browser != browser_not_a_browser)
	{
		ini_open("youre.cache");
		ini_write_string("cache","code_verifier",_pkce.code_verifier);
		ini_close();
		url_open(_url);
	}

}

function on_code_challenge_created(_challenge)
{
	_pkce.code_challenge = _challenge;
	
	if(_show_login_on_pkce_challenge_code_created){
		_show_login();
		_show_login_on_pkce_challenge_code_created = false;
	}
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
		
	
	if(os_browser != browser_not_a_browser)
	{
		var _current_url = get_current_url();
		var _has_code = string_count("code=",_current_url)==1;
		if(_has_code)
		{
			ini_open("youre.cache");
			verifier = ini_read_string("cache", "code_verifier", "");
			ini_close();
			_pkce.code_verifier = verifier;
			_pkce.rehash();
			_check_url(_current_url);
			return;
		}
	}

	ini_open("youre.cache");
	var _access_token = ini_read_string("session", "access_token", "");
	ini_close();
	
	if(_access_token != "")
	{
		_request_userinfo(_access_token);
		return;
	}

	if(_pkce.code_challenge == "")
	{
		_show_login_on_pkce_challenge_code_created = true;
		return;
	}

	_show_login();
	
}











# Youre-for-GameMaker

> The YOURE Sign In Extension for GameMaker Studio provides a simple and convenient way to integrate YOURE sign-in functionality. With this extension code, users can quickly and easily sign in to YOURE and access their accounts without leaving the Game.


### Supported Platforms: 
Desktop (Windows), HTML5

### Install
Download the lastest release and import (Local Package) it to your GameMaker Studio Project

## Usage

```gml

youre_auth =  instance_create_depth(0,0,0,obj_youre_auth);
// Following data is for testing only, YOURE Games will provide you with actual data
var _domain = "stage-youre-id.eu.auth0.com";
var _client_id = "{YOURE_CLIENT_ID}";
var _custom_redirect_url = "{GAME_URL_FOR_REDIRECT}"; // optional

youre_auth.init(_domain,_client_id,_custom_redirect_url);

var _on_auth_success = function(_user_id, _additional_user_info) {
	show_debug_message("YoureAuthUserId:"+_user_id);
};

// only windows supported at the moment
var _width = 640;
var _height = 750;

youre_auth.authenticate( _width, _height, _on_auth_success);

```

## Known Issues
* Do not remove the 'locales' directory within 'datafiles' directory. It is needed for Windows Desktop platform.


## Force close login layer (only Desktop and Mobile)
```gml
youre_auth.close();
```

## Logout
```gml
youre_auth.logout();
```

## License
Copyright © 2023, YOURE Games, The MIT License (MIT)

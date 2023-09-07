# Youre-for-GameMaker
YOURE Extension for GameMaker Studio

# Youre-for-GameMaker

> The YOURE Sign In Extension for GameMaker Studio provides a simple and convenient way to integrate YOURE sign-in functionality. With this extension code, users can quickly and easily sign in to YOURE and access their accounts without leaving the Game.


### Supported Platforms: 
Desktop (Windows)

### Install
Download the lastest release and import (Local Package) it to your GameMaker Studio Project

## Usage

```gml

youre_auth =  instance_create_depth(0,0,0,obj_youre_auth);
youre_auth.init("stage-youre-id.eu.auth0.com","dNiiO1yimIBfQivgiHAZ7aRTwHXhPqcg");


var _on_auth_success = function(_user_id, _additional_user_info) {
	show_debug_message("YoureAuthUserId:"+_user_id);
};

// only windows supports custom size at the moment
var _width = 640;
var _height = 750;

youre_auth.authenticate( _width, _height, _on_auth_success

```

## Logout
```gml
youre_auth.logout();
```

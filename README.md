# Youre-for-GameMaker

> The YOURE Sign In Extension for GameMaker Studio provides a simple and convenient way to integrate YOURE sign-in functionality. With this extension code, users can quickly and easily sign in to YOURE and access their accounts without leaving the Game.


### Supported Platforms: 
Desktop (Windows), HTML5, Android, iOS

### Install
Download the lastest release and import (Local Package) it to your GameMaker Studio Project

## Usage

```gml

youre_auth =  instance_create_depth(0,0,0,obj_youre_auth);
// Following data is for testing only, YOURE Games will provide you with actual data
var _domain = "stage-youre-id.eu.auth0.com";
var _client_id = "{YOURE_CLIENT_ID}";
var _custom_redirect_url = "{GAME_URL_FOR_REDIRECT}"; // optional, only relevant for web platform

youre_auth.init(_domain,_client_id,_custom_redirect_url);

var _on_auth_success = function(_user_id, _additional_user_info) {
	show_debug_message("YoureAuthUserId:"+_user_id);
};

// only windows supported at the moment
var _width = 640;
var _height = 750;

youre_auth.authenticate( _width, _height, _on_auth_success);

```
## HTML5 Installation:
The authentication process works with a redirect. The user is taken out of the app for login and then brought back to the game application. To do this, a redirect URL (typically the URL of the game) must be specified in the authentication configuration. This URL is used to pass the required login data to the game application.

 
## Windows Desktop Installation:
Do not remove the 'locales' directory within 'datafiles' directory.
  
## Android Installation:
When developing with GameMaker Studio for Android, there is an IDE error that does not recognize essential classes. For this reason, please manually copy the following Java files as follows:
1. Copy 'PATH_TO_YOUR_GAMEMAKER_PROJECT\extensions\WebView\AndroidSource\Java\\__WebViewGM.java__' to 'C:\ProgramData\GameMakerStudio2\Cache\runtimes\\*runtime-2023.6.0.139*\android\runner\ProjectFiles\src\main\java\'
2. Copy 'PATH_TO_YOUR_GAMEMAKER_PROJECT\extensions\Youre\AndroidSource\Java\\__YoureGM.java__' to 'C:\ProgramData\GameMakerStudio2\Cache\runtimes\\*runtime-2023.6.0.139*\android\runner\ProjectFiles\src\main\java\'

The directory '*runtime-2023.6.0.139*' within the path provided above may be named differently or similarly on your system.



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

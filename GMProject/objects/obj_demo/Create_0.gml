
// init YOURE SDK object
youre_auth =  instance_create_depth(0,0,0,obj_youre_auth);

var _on_auth_success = function(_user_id, _additional_user_info) {
	show_debug_message("YoureAuthUserId:"+_user_id);
};

youre_auth.init("stage-youre-id.eu.auth0.com","dNiiO1yimIBfQivgiHAZ7aRTwHXhPqcg");

//youre_auth.logout();


// only windows supported at the moment
var _width = 640;
var _height = 750;

youre_auth.authenticate( _width, _height, _on_auth_success);
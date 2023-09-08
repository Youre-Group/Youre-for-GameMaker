

youre_auth =  instance_create_depth(0,0,0,obj_youre_auth);
// Following data is for testing only, YOURE Games will provide you with actual data
var _domain = "stage-youre-id.eu.auth0.com";
var _client_id = "dNiiO1yimIBfQivgiHAZ7aRTwHXhPqcg";
var _custom_redirect_url = "https://yre-gamemaker-test.s3.amazonaws.com/index.html";

youre_auth.init(_domain,_client_id,_custom_redirect_url);

var _on_auth_success = function(_user_id, _additional_user_info) {
	show_debug_message("YoureAuthUserId:"+_user_id);
};


// only windows supported at the moment
var _width = 640;
var _height = 750;

youre_auth.authenticate( _width, _height, _on_auth_success);
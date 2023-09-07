
function SessionCache() constructor {

	file_path = "session.json";
	
	static save_json = function(_data) 
	{
	    var _json_string = json_encode(_data);
	    var _buffer      = buffer_create(string_byte_length(_json_string) + 1, buffer_fixed, 1);
	    buffer_write(_buffer, buffer_string, _json_string);
	    buffer_save(_buffer, file_path);
	    buffer_delete(_buffer);
	}
	
	static clear = function()
	{
		save_json(ds_map_create());
	}
	
	static load = function() 
	{
	    var _buffer = buffer_load(file_path);
	    if (_buffer != -1)
	    {
	        var _json_string = buffer_read(_buffer, buffer_string);
	        buffer_delete(_buffer);
	        return json_decode(_json_string);
	    }
	    else
	    {
	        return undefined;
	    }
	}
}
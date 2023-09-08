
function SessionCache() constructor {

	
	
	static save_json = function(_data, _file_path) 
	{
	    var _json_string = json_encode(_data);
	    var _buffer      = buffer_create(string_byte_length(_json_string) + 1, buffer_fixed, 1);
	    buffer_write(_buffer, buffer_string, _json_string);
	    buffer_save(_buffer, _file_path);
	    buffer_delete(_buffer);
	}
	
	static clear = function()
	{
		save_json(ds_map_create());
	}
	
	static load = function(_file_path) 
	{
		var _buffer = buffer_create(0, buffer_grow, 1);
	  
	    var _load_id = buffer_load_async(_buffer,_file_path,0,-1);
	    return _load_id;
	   /*if (_buffer != -1)
	    {
	        var _json_string = buffer_read(_buffer, buffer_string);
	        buffer_delete(_buffer);
			_complete_callback(json_decode(_json_string));
	    }
	    else
	    {
			_complete_callback(undefined);
	    }*/
	}
}
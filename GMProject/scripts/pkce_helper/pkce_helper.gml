function PKCEHelper() constructor {
	

	_generate_nonce = function()
	{
		var _char_set = "abcdefghijklmnopqrstuvwxyz123456789";
		var _string_length = 128;
		var _random_string = "";
		for (var _i = 0; _i < _string_length; _i++) {
			var _random_char_index = irandom_range(1, string_length(_char_set));
			_random_string += string_char_at(_char_set, _random_char_index);
		}
		return _random_string;
	}

	_generate_challenge = function(_code_verifier)
	{
		var _hash = string_sha256(_code_verifier)
		return HexToBase64(string(_hash));
	}
	
	code_verifier = _generate_nonce();
	code_challenge = _generate_challenge(code_verifier);
	

}
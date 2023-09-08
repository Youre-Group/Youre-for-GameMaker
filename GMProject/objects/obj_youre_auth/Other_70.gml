if ds_map_find_value(async_load, "type") == "youre_challenge_generator"
{
	var _challenge = ds_map_find_value(async_load, "challenge");
	on_code_challenge_created(_challenge);
}

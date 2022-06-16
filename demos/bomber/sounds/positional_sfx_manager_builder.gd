extends Resource
class_name positional_sfx_manager

signal request_playing(sfx_name)

func play(sfx_name : String, global_position):
	emit_signal("request_playing", sfx_name, global_position)

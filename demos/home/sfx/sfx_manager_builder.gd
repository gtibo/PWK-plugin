extends Resource
class_name sfx_manager

signal request_playing(sfx_name)

func play(sfx_name : String, db = null):
	emit_signal("request_playing", sfx_name, db)

extends Node

export(Resource) var main_sfx_manager
export(Array, Resource) var known_sfx
var sfx_map = {}

func _ready():
	main_sfx_manager.connect("request_playing", self, "on_request_playing")
	for sfx in known_sfx:
		sfx_map[sfx.id] = sfx
		
func on_request_playing(sfx_name : String, db = null):
	var audio_db = 0
	if db != null:
		audio_db = db
	else:
		audio_db = sfx_map[sfx_name].db
	var audio_sp = AudioStreamPlayer.new()
	add_child(audio_sp)
	audio_sp.stream = sfx_map[sfx_name].sound
	audio_sp.play()
	audio_sp.volume_db = audio_db
	yield(audio_sp, "finished")
	audio_sp.queue_free()

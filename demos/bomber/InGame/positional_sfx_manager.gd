extends Node2D

export(Resource) var main_sfx_manager
export(Array, Resource) var known_sfx
var sfx_map = {}

func _ready():
	main_sfx_manager.connect("request_playing", self, "on_request_playing")
	for sfx in known_sfx:
		sfx_map[sfx.id] = sfx
		
func on_request_playing(sfx_name : String, sfx_position):
	var audio_sp = AudioStreamPlayer2D.new()
	add_child(audio_sp)
	audio_sp.global_position = sfx_position
	audio_sp.stream = sfx_map[sfx_name].sound
	audio_sp.play()
	yield(audio_sp, "finished")
	audio_sp.queue_free()

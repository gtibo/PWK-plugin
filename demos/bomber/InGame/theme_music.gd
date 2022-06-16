extends AudioStreamPlayer

export(AudioStream) var menu_theme
export(AudioStream) var ingame_theme

func _on_StateMachine_transitioned(state_name):
	match state_name:
		"Menu":
			stream = menu_theme
			play()
		"InGame":
			stream = ingame_theme
			play()

extends ColorRect

func _ready():
	material = material.duplicate()


func set_theme(t):
	material.set_shader_param("stroke_color", t.stroke)
	material.set_shader_param("main_color", t.main)
	material.set_shader_param("second_color", t.second)

func set_state(state_name):
	match state_name:
		"smile":
			$AnimationPlayer.play("smile")
		"sleep":
			$AnimationPlayer.play("sleep")

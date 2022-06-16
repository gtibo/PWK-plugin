extends AnimationTree

export(NodePath) onready var sprite = get_node(sprite) as ColorRect

onready var state_machine = self["parameters/action/playback"]


func _on_StateMachine_transitioned(state_name):
	match state_name:
		"Idle":
			state_machine.travel("Idle")
		"Run":
			state_machine.travel("Run")
		"Slide":
			state_machine.travel("Slide")
		"KO":
			state_machine.travel("Fall")
		"Stunned":
			state_machine.travel("Fall")
		"Dance":
			state_machine.travel("Idle")
					
func _on_Air_fall():
	state_machine.travel("Fall")

func _on_Air_jump():
	state_machine.travel("Jump")

func _on_Player_punch():
	self.set("parameters/punch/active", true)

func _on_Player_changeDirection(direction):
	sprite.material.set_shader_param("flip", direction > 0)

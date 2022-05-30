extends State

func enter(_msg := {}) -> void:
	owner.animation.play("walk")

func physics_update(delta: float) -> void:
	owner.check_input()
	if(owner.input_vel.length() == 0):
		state_machine.transition_to("Idle")
		return
	if owner.input_vel.x > 0:
		owner.set_direction(-1)
	elif owner.input_vel.x < 0:
		owner.set_direction(1)
	owner.check_movement(delta)

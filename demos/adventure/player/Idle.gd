extends State

func enter(_msg := {}) -> void:
	owner.animation.play("idle")

func physics_update(delta: float) -> void:
	if owner.locked:
		return
	owner.check_input()
	if(owner.input_vel.length() > 0):
		state_machine.transition_to("Walk")
		return
	owner.check_movement(delta)

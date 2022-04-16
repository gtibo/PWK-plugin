extends State
class_name PlatformerStateRun

func enter(_msg := {}) -> void:
	if !owner.is_on_floor():
		state_machine.transition_to("Air")
		return
	owner.snap_vector = Vector2.DOWN * 16
	
func physics_update(delta) -> void:
	if Input.is_action_pressed(owner.jump_button):
		owner.snap_vector = Vector2.ZERO
		state_machine.transition_to("Air", {do_jump = true})
		return
	if !owner.is_on_floor():
		state_machine.transition_to("Air")
		return
	if owner.x_input == 0:
		state_machine.transition_to("Idle")
		return
	owner.apply_x_inputs(delta)
	owner.update_velocity(delta)

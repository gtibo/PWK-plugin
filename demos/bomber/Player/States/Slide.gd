extends State

var slide_normal = Vector2.ZERO

func enter(_msg := {}) -> void:
	slide_normal = owner.get_last_slide_collision().normal

func physics_update(delta) -> void:
	if !owner.is_on_wall():
		state_machine.transition_to("Air")
		return
	owner.apply_x_inputs(delta)
	owner.apply_gravity(delta)
	owner.apply_wall_friction(delta)
	owner.update_velocity(delta)
	if Input.is_action_just_pressed(owner.jump_button):
		owner.velocity.x = slide_normal.x * owner.SPEED
		state_machine.transition_to("Air", {do_jump = true})

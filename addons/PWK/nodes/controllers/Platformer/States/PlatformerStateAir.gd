extends State
class_name PlatformerStateAir

func enter(_msg := {}) -> void:
	owner.snap_vector = Vector2.ZERO
	if _msg.has("do_jump"):
		owner.velocity.y = -owner.SPEED * 2


func physics_update(delta) -> void:
	owner.apply_x_inputs(delta)
	owner.apply_gravity(delta)
	owner.apply_air_friction(delta)
	owner.update_velocity(delta)
	if owner.is_on_floor() == false: return
	owner.snap_vector = Vector2.DOWN * 10
	if(owner.x_input == 0):
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Run")

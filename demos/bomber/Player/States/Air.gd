extends PlatformerStateAir

var is_falling : bool = false;

signal fall
signal jump

func enter(_msg := {}) -> void:
	owner.snap_vector = Vector2.ZERO
	if _msg.has("do_jump"):
		emit_signal("jump")
		owner.velocity.y = -owner.SPEED * owner.get_speed_boost(0.2) * 2
	is_falling = false
	
func physics_update(delta) -> void:
	var impact_velocity_y = owner.velocity.y
	owner.apply_x_inputs(delta)
	owner.apply_gravity(delta)
	owner.apply_air_friction(delta)
	owner.update_velocity(delta)
	if owner.is_on_floor():
		var impact_db = range_lerp(impact_velocity_y, 0, owner.TOP_SPEED, -20, 0)
		owner.main_sfx_manager.play("landing", impact_db)
		owner.snap_vector = Vector2.DOWN * 10
		if(owner.x_input == 0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")

	if is_falling == false:
		if owner.velocity.y > 0: 
			is_falling = true
			emit_signal("fall")
	if owner.is_on_wall() && owner.x_input != 0:
		state_machine.transition_to("Slide")
	owner.check_punch()

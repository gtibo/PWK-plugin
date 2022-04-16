extends State

func physics_update(delta) -> void:
	owner.apply_gravity(delta)
	if owner.is_on_floor():
		owner.apply_ground_friction(delta)
	else:
		owner.apply_air_friction(delta)
	owner.update_velocity(delta)

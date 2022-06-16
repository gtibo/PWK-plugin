extends State

func enter(_msg := {}) -> void:
	get_node("../../Collision").call_deferred("set_disabled", true)
	
func physics_update(delta) -> void:
	owner.apply_gravity(delta)
	owner.rotate(10*delta)
	owner.apply_air_friction(delta)
	owner.update_velocity(delta)

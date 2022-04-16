extends State

export(NodePath) onready var stun_timer = get_node(stun_timer)

func enter(_msg := {}) -> void:
	stun_timer.start()
	yield(stun_timer, "timeout")
	if state_machine.state.name == "KO": return
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Air")
	
func physics_update(delta) -> void:
	owner.apply_gravity(delta)
	if owner.is_on_floor():
		owner.apply_ground_friction(delta)
	else:
		owner.rotate(10*delta)
		owner.apply_air_friction(delta)
	owner.update_velocity(delta)

func exit() -> void:
	owner.rotation = 0

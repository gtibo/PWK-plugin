extends State


var start_time = 0
var max_time = 2000

func enter(_msg := {}) -> void:
	start_time = OS.get_ticks_msec()

func update(delta) -> void:
	var elapsed =  OS.get_ticks_msec() - start_time
	if elapsed >= max_time || Input.is_action_just_released(owner.bomb_button):
		throw(elapsed)
	var shake = range_lerp(elapsed, 0, max_time, .2, 1)
	Input.start_joy_vibration(owner.controller_index,0,shake,.1)
	
func throw(elapsed):
	var power = range_lerp(elapsed, 0, max_time, 0, 2)
	if power > .2:
		owner.throw_bomb(power)
	# Throw bomb with power
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Air")

func exit() -> void:
	Input.stop_joy_vibration(owner.controller_index)

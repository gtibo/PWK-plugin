extends State


var start_time = 0
var max_time = 2000

func enter(_msg := {}) -> void:
	start_time = OS.get_ticks_msec()

func update(delta) -> void:
	if owner.x_input != 0:
		owner.check_direction()
	var t = OS.get_ticks_msec()
	var elapsed =  t - start_time
	if elapsed >= max_time || Input.is_action_just_released(owner.bomb_button):
		throw(elapsed)
	var shake = range_lerp(elapsed, 0, max_time, .2, 10)
	get_node("../../Sprite").rect_rotation = sin(t * 0.1) * shake
	#Input.start_joy_vibration(owner.controller_index,0,shake,.1)
	
func throw(elapsed):
	var power = range_lerp(elapsed, 0, max_time, 0.0, 1.0)
	if power > .1:
		# Throw bomb with power
		owner.throw_bomb(power)
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Air")

func exit() -> void:
	yield(get_tree(), "idle_frame")
	get_node("../../Sprite").rect_rotation = 0
	#Input.stop_joy_vibration(owner.controller_index)

extends State

export(NodePath) onready var game_holder = get_node(game_holder)
export(NodePath) onready var pause_screen = get_node(pause_screen)

func handle_input(_event):
	if owner.in_bluring: return
	if Input.is_action_pressed("0_select_button"):
		state_machine.transition_to("InGame")
		return
	if Input.is_action_pressed("0_x_button"):
		owner.set_fade(true)
		yield(owner, "fade")
		for child in game_holder.get_children():
			child.queue_free()
		owner.set_blur(false)
		state_machine.transition_to("Home")
		
func enter(msg := {}):
	get_tree().paused = true
	owner.set_blur(true)
	owner.set_actions([
		["select","Unpause demo"],
		["x","Leave demo"]
		],
		Color.white)
	pause_screen.show()
	
func exit(msg := {}):
	get_tree().paused = false
	pause_screen.hide()

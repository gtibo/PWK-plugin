extends State

export(NodePath) onready var game_holder = get_node(game_holder)

func handle_input(_event):
	if owner.in_bluring: return
	if Input.is_action_pressed("0_select_button"):
		state_machine.transition_to("Pause")
		return

func enter(msg := {}):
		owner.reset_actions()
		if msg.has("scene"):
			owner.set_fade(true)
			yield(owner, "fade")
			var scene = load(msg.scene).instance()
			game_holder.add_child(scene)
			owner.set_fade(false)
			owner.set_visible(false)
		else:
			owner.set_blur(false)
			yield(owner, "blured")
			owner.set_visible(false)
	
func exit():
	owner.set_visible(true)

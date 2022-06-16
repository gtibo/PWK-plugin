extends State

export(NodePath) onready var bg = get_node(bg)

func handle_input(_event):
	if owner.in_bluring: return
	if Input.is_action_pressed("0_a_button"):
		state_machine.transition_to("Selection")

func enter(_msg := {}):
	owner.set_actions([["a","Play"], ["y","Info"]], Color.black)
	bg.show()

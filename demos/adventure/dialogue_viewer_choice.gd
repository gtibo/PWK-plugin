extends State

export(PackedScene) var choice_scene
export(NodePath) onready var bubble_node = get_node(bubble_node) as Node2D

var current_choice = null
var choice_size = 0
var choice_index = 0


func handle_input(_event):
	if owner.bubble_busy: return
	if Input.is_action_just_pressed("0_a_button"):
		confirm_choice()
	if Input.is_action_just_pressed("0_down_button"):
		incr_choice(-1)
	if Input.is_action_just_pressed("0_up_button"):
		incr_choice(1)

func enter(msg := {}):
	choice_index = 0
	current_choice = msg.next
	choice_size = current_choice.size()
	bubble_node.set_choices(current_choice)
	
func exit():
	bubble_node.remove_choices()

func confirm_choice():
	owner.current_step_id = current_choice[choice_index].target
	state_machine.transition_to("Read")

func incr_choice(amount):
	var old_index = choice_index
	choice_index = fposmod(choice_index + amount, choice_size)
	
	bubble_node.select_choice(old_index, choice_index)

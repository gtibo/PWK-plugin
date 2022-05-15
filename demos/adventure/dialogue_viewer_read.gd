extends State

export(NodePath) onready var bubble_node = get_node(bubble_node) as Node2D

var is_ended = false

func handle_input(_event):
	if owner.bubble_busy: return
	if Input.is_action_just_pressed("0_a_button"):
		get_tree().set_input_as_handled()
		if is_ended:
			owner.desactivate()
		else:
			progress()

func enter(_msg := {}):
	is_ended = false
	owner.show()
	progress()
	
func progress():
	var current_step = owner.dialogue_data[owner.current_step_id]
	var line = current_step.lines.pop_front()
	var actor = owner.story_manager.known_actors[current_step.actor]
	bubble_node.actor_anchor = actor.anchor
	if line != null:
		owner.bubble_busy = true
		bubble_node.write(line)
		if current_step.lines.size() > 0:
			# Continue dialogue
			return
	
	# End of lines
	# Check if there is a choice to make?
	if current_step.has("next"): 
		if typeof(current_step["next"]) == TYPE_ARRAY:
			# Choice
			state_machine.transition_to("Choice", {"next": current_step["next"]})
			return
		else:
			# Go to another step
			owner.current_step_id = current_step.next
	else:
		# Close dialogue
		is_ended = true

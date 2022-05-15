extends Node2D
export (Resource) var dialogue_manager

var active = false

func _input(event):
	if !active: return
	if Input.is_action_just_pressed("0_a_button"):
		dialogue_manager.progress()

func _ready():
	dialogue_manager.connect("dialogue_start", self, "on_dialogue_start")
	dialogue_manager.connect("dialogue_end", self, "on_dialogue_end")
	dialogue_manager.connect("dialogue_progress", self, "on_dialogue_progress")
	hide()
	
func on_dialogue_start():
	show()
	active = true
	
func on_dialogue_progress(block):
	if block.actor && block.actor.anchor:
		var next_anchor = block.actor.anchor
		var previous_anchor = $Bubble.actor_anchor
		$Bubble.actor_anchor = next_anchor
	$Bubble.write(block.line)
	
func on_dialogue_end():
	active = false
	$Bubble.actor_anchor = null
	hide()

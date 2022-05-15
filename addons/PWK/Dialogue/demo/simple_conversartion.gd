extends Node2D
export (Resource) var dialogue_manager
export (Resource) var dialogue_test
var can_launch_dialogue = true

func _input(event):
	if !can_launch_dialogue: return
	if Input.is_action_just_pressed("0_b_button"):
		dialogue_manager.speak(dialogue_test)

func _ready():
	dialogue_manager.connect("dialogue_start", self, "on_dialogue_start")
	dialogue_manager.connect("dialogue_end", self, "on_dialogue_end")

func on_dialogue_start():
	can_launch_dialogue = false
	
func on_dialogue_end():
	can_launch_dialogue = true

extends Node

onready var timer = $Timer

func _input(event):
	if event is InputEventMouseMotion:
		timer.start()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

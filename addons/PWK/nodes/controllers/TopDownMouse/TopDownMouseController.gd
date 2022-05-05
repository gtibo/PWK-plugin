extends KinematicBody2D
class_name TopDownMouseController, "res://addons/PWK/icones/joystick_icon.svg"
export (int,0,3) var controller_index setget set_controller_index

func set_controller_index(value):
	controller_index = value

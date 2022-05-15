extends KinematicBody2D
class_name TopdownController

export (int,0,3) var controller_index setget set_controller_index
export var max_speed = 200

var left_button
var right_button
var top_button
var bottom_button

func _ready():
	set_controller_index(controller_index)

func set_controller_index(value):
	controller_index = value
	left_button = str(controller_index) + "_left_button"
	right_button = str(controller_index) + "_right_button"
	top_button = str(controller_index) + "_up_button"
	bottom_button = str(controller_index) + "_down_button"
	
func check_movement(delta):
	var x_input = Input.get_axis(left_button, right_button)
	var y_input = Input.get_axis(top_button, bottom_button)
	var velocity = Vector2(x_input, y_input)
	velocity = velocity.normalized() * max_speed
	move_and_slide(velocity, Vector2.UP)
	

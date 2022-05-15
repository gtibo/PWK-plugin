extends KinematicBody
class_name TopDownController3D
export (int,0,3) var controller_index setget set_controller_index
export var max_speed = 2
var gravity = 100

var left_button
var right_button
var top_button
var bottom_button
var velocity = Vector3.ZERO

var input_vel : Vector2 = Vector2.ZERO

func _ready():
	set_controller_index(controller_index)

func set_controller_index(value):
	controller_index = value
	left_button = str(controller_index) + "_left_button"
	right_button = str(controller_index) + "_right_button"
	top_button = str(controller_index) + "_up_button"
	bottom_button = str(controller_index) + "_down_button"

func check_input():
	var x_input = Input.get_axis(left_button, right_button)
	var y_input = Input.get_axis(top_button, bottom_button)
	input_vel = Vector2(x_input, y_input).normalized() * max_speed
	
func check_movement(delta):
	velocity.x = input_vel.x
	velocity.z = input_vel.y
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)

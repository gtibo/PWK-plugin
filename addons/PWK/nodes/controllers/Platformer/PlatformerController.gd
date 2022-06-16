extends KinematicBody2D
class_name PlatformerController, "res://addons/PWK/icones/joystick_icon.svg"

const SPEED = 300.0
var velocity = Vector2.ZERO
const TOP_SPEED = 1000.0
var gravity = 1300.0
var x_input = 0
var friction = 10
var acceleration = 10
var snap_vector = Vector2.ZERO

export (int,0,3) var controller_index setget set_controller_index
var jump_button
var left_button
var right_button

func set_controller_index(value):
	controller_index = value
	jump_button = str(controller_index) + "_a_button"
	left_button = str(controller_index) + "_left_button"
	right_button = str(controller_index) + "_right_button"

func _ready():
	set_controller_index(controller_index)

func _input(event):
	x_input = Input.get_axis(left_button, right_button)
	
func apply_x_inputs(delta):
	if x_input == 0: return
	velocity.x = lerp(velocity.x, x_input * SPEED, acceleration * delta)
	
func apply_ground_friction(delta):
	velocity.x = lerp(velocity.x, 0, friction * delta)
	
func apply_wall_friction(delta):
	velocity.y = lerp(velocity.y, 0, friction * delta)
	
func apply_air_friction(delta):
	velocity.x = lerp(velocity.x, 0, friction * 0.1 * delta)

func apply_gravity(delta):
	velocity.y += gravity * delta

func update_velocity(delta):
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, true)
	velocity = velocity.clamped(TOP_SPEED)

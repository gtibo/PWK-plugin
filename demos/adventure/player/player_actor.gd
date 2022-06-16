extends KinematicActor
export(Resource) var story_manager
var locked = false
export (int,0,3) var controller_index setget set_controller_index

var left_button
var right_button
var top_button
var bottom_button
var velocity = Vector3.ZERO

var input_vel : Vector2 = Vector2.ZERO

func _ready():
	#max_speed = 2
	set_controller_index(controller_index)
	story_manager.connect("action_started", self, "lock")
	story_manager.connect("action_ended", self, "unlock")
	
func lock():
	locked = true
	$StateMachine.transition_to("Idle")
	
	
func unlock():
	locked = false
	$StateMachine.transition_to("Idle")
	
func set_controller_index(value):
	controller_index = value
	left_button = str(controller_index) + "_left_button"
	right_button = str(controller_index) + "_right_button"
	top_button = str(controller_index) + "_up_button"
	bottom_button = str(controller_index) + "_down_button"

func check_input():
	var x_input = Input.get_axis(left_button, right_button)
	var y_input = Input.get_axis(top_button, bottom_button)
	input_vel = Vector2(x_input, y_input).normalized()
	
func check_movement(delta):
	velocity.x = input_vel.x * max_speed
	velocity.z = input_vel.y * max_speed
	velocity.y = 0
	velocity = move_and_slide_with_snap(velocity, Vector3.DOWN * 4, Vector3.UP, true)

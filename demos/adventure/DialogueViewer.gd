extends Node
export(Resource) var dialogue_manager
export(Resource) var story_manager

onready var SM : StateMachine = $StateMachine

var current_step_id = ""
var dialogue_data = null

var bubble_busy = false

func _ready():
	dialogue_manager.connect("dialogue_start", self, "activate")
	$Bubble.connect("wrote", self, "set_unbusy")
	
func set_unbusy():
	bubble_busy = false
	
func activate():
	$Bubble.open()
	current_step_id = "0"
	dialogue_data = dialogue_manager.current_dialogue_data
	SM.transition_to("Read")
	
func desactivate():
	$Bubble.close()
	yield($Bubble, "closed")
	dialogue_data = null
	dialogue_manager.end()
	SM.transition_to("Disabled")
	

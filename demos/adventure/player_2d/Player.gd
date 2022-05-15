extends TopdownController

export(Resource) var dialogue_manager
export(NodePath) onready var state_machine = get_node("StateMachine") as StateMachine

func _ready():
	dialogue_manager.connect("dialogue_start", self, "on_dialogue_start")
	dialogue_manager.connect("dialogue_end", self, "on_dialogue_end")

func on_dialogue_start():
	state_machine.transition_to("Waiting")
	
func on_dialogue_end():
	state_machine.transition_to("Idle")

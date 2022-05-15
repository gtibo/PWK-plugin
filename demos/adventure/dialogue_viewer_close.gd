extends State

func enter(_msg := {}) -> void:
	state_machine.transition_to("Disabled")

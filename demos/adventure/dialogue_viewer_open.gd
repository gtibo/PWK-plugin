extends State

func enter(_msg := {}) -> void:
	owner.show()
	state_machine.transition_to("Read")

extends State

export(PackedScene) var InGameScene

func enter(_msg := {}) -> void:
	var InGame = InGameScene.instance()
	InGame.connect("end", self, "on_end")
	owner.switch_scene(InGame)

func on_end():
	state_machine.transition_to("Menu")

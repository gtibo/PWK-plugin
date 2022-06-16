extends State

export(PackedScene) var MenuScene

func enter(_msg := {}) -> void:
	var menu = MenuScene.instance()
	menu.connect("selection_ok", self, "on_selection")
	owner.switch_scene(menu)
	
func on_selection():
	state_machine.transition_to("InGame")

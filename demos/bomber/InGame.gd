extends State

export(PackedScene) var InGameScene
export(Resource) var RuleManager
func _ready():
	RuleManager.connect("victory", self, "on_victory")

func enter(_msg := {}) -> void:
	var InGame = InGameScene.instance()
	owner.switch_scene(InGame)

func on_victory(_player):
	state_machine.transition_to("Menu")

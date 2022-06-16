extends cameraFollow
export(Resource) var RuleManager

func _ready():
	RuleManager.connect("ko", self, "on_ko")
	RuleManager.connect("player_list_update", self, "set_targets")

func set_targets(player_list):
	targets = player_list

func on_ko(player):
	remove_target(player)

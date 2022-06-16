extends Control

export(PackedScene) var PlayerHUD
export(Resource) var RuleManager

onready var list_node = $PlayerList

var hud_list = {}

func _ready():
	RuleManager.connect("player_list_update", self, "on_player_list_update")
	RuleManager.connect("action_update", self, "on_action_update")
	RuleManager.connect("victory", self, "on_victory")
	RuleManager.connect("ko", self, "on_player_ko")

func on_victory(_player):
	hide()
	
func on_player_list_update(playerlist):
	for player in playerlist:
		var p_hud = PlayerHUD.instance()
		p_hud.set_theme(RuleManager.themes[player.controller_index])
		list_node.add_child(p_hud)
		hud_list[player.name] = p_hud
	
func on_player_ko(player):
	hud_list[player.name].set_ko()
	
func on_action_update(player, action_name, value):
	hud_list[player.name].set_action(action_name, value)

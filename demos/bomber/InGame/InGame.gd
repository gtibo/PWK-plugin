extends Node2D

export(Resource) var RuleManager
export(PackedScene) var player_scene

signal end

func _ready():
	var player_list = spawn_players()
	RuleManager.set_player_list(player_list)
	
func spawn_players():
	var players = []
	var spawns = []
	for child in $Spawns.get_children():
		spawns.append(child.position)
	spawns.shuffle()
	for i in RuleManager.player_info.size():
		var ctrl_index = RuleManager.player_info[i]
		var new_player = player_scene.instance()
		new_player.setup(spawns[i], ctrl_index)
		new_player.hit_container = $HitsManager
		players.append(new_player)
		$Players.add_child(new_player)
	return players

func _on_WinScreen_announcer_end():
	emit_signal("end")

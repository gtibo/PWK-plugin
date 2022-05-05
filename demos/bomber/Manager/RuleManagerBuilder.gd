extends Resource
class_name bomber_rule_manager

signal victory
signal ko
signal player_list_update

var player_info = []
var player_list = []

signal throw_bomb(player, power, spawn_vel)
signal punch(player)
signal explosion

signal action_update

export (Array, Resource) var themes = []

func request_punch(player):
	emit_signal("punch", player)
	
func request_bomb(player, power, spawn_vel):
	emit_signal("throw_bomb", player, power, spawn_vel)

func explode(position):
	emit_signal("explosion", position)

func has_player_info(ctrl_index):
	return player_info.has(ctrl_index)

func add_player_info(ctrl_index):
	player_info.append(ctrl_index)
	
func remove_player_info(ctrl_index):
	player_info.erase(ctrl_index)
	
func set_player_list(new_player_list):
	player_list = new_player_list
	emit_signal("player_list_update", player_list)

func player_action_update(player, action_name, value):
	emit_signal("action_update",player, action_name, value)

func player_ko(player):
	emit_signal("ko", player)
	if player in player_list:
		player_list.erase(player)
	if player_list.size() == 1:
		emit_signal("victory", player_list[0])

extends Control

export(Resource) var g_data_test
export(Array, Resource) var known_games
export(NodePath) onready var gameinfo_node = get_node(gameinfo_node) as Node
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer

signal transitioned

var current_displayed_game_id = 0

func _ready():
	gameinfo_node.setup(known_games[0])
	
func selection_data():
	return known_games[current_displayed_game_id]

func switch(direction : int):
	var next_displayed_id = posmod(current_displayed_game_id + direction, known_games.size())
	current_displayed_game_id = next_displayed_id
	if direction < 0:
		animation_player.play("GoLeft")
	else:
		animation_player.play("GoRight")
	yield(animation_player, "animation_finished")
	gameinfo_node.setup(known_games[current_displayed_game_id])
	animation_player.play("Appear")
	emit_signal("transitioned")

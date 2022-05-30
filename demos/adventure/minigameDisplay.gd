extends Node

export(Array, Resource) var known_mini_games
export(Resource) var mini_game_manager

func _ready():
	var minigame_table = {}
	for mini_game in known_mini_games:
		minigame_table[mini_game.name] = mini_game
	known_mini_games = minigame_table
	mini_game_manager.connect("game_start", self, "on_mini_game_start")
	
func on_mini_game_start(game_name):
	var game_scene = known_mini_games[game_name].scene.instance()
	add_child(game_scene)
	var score = yield(game_scene, "ended")
	mini_game_manager.end(score)
	for child in get_children():
		child.queue_free()
	

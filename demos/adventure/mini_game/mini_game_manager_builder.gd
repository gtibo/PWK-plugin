extends Resource
class_name minigameManager

signal game_start(game_name)
signal game_end(score)

func start(game_name):
	emit_signal("game_start", game_name)

func end(score):
	emit_signal("game_end", score)

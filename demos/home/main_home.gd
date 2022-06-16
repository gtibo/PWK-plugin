extends Node

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var footer = get_node(footer) as Control
export(Resource) var main_sfx_manager

var current_game_info = null

var in_bluring = false

signal fade
signal blured

func _ready():
	$Theme.play()
	$CanvasLayer/Menu/BlackRect.hide()
	
func set_blur(state):
	in_bluring = true
	if state:
		animation_player.play("blur")
	else:
		animation_player.play_backwards("blur")
	yield(animation_player, "animation_finished")
	in_bluring = false
	emit_signal("blured")

func set_actions(actions_list, font_color):
	footer.display_actions(actions_list, font_color)

func reset_actions():
	footer.reset_actions()

func set_visible(value):
	if value:
		$Theme.play()
		$CanvasLayer/Menu.show()
	else:
		$Theme.stop()
		$CanvasLayer/Menu.hide()
	
func set_fade(value):
	$CanvasLayer/Menu/BlackRect.show()
	if value:
		animation_player.play("hide_menu")
	else:
		animation_player.play_backwards("hide_menu")
	yield(animation_player, "animation_finished")
	$CanvasLayer/Menu/BlackRect.hide()
	emit_signal("fade")
	
func _on_StateMachine_transitioned(state_name):
	main_sfx_manager.play("open")

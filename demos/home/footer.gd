extends Control

export(PackedScene) var action_scene
onready var navigation = $Navigation
onready var animation_player = $AnimationPlayer

export(Array, Resource) var known_icons
var icon_map = {}

func _ready():
	for icon in known_icons:
		icon_map[icon.icon_id] = icon.icon_texture
# Example
# [["a", "Launch Demo"], ["b", "Close popup"]]
func display_actions(action_list, font_color = Color.white):
	animation_player.stop(true)
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	reset_actions()
	animation_player.play("RESET")

	for action in action_list:
		var action_node = action_scene.instance()
		navigation.add_child(action_node)
		action_node.setup(icon_map[action[0]], action[1], font_color)
	
	yield(get_tree(), "idle_frame")
	
	for action_node in navigation.get_children():
		action_node.appear()
		yield(action_node, "appeared")

func reset_actions():
	for child in navigation.get_children():
		child.queue_free()

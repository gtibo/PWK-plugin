extends HBoxContainer

export(NodePath) onready var title_node = get_node(title_node) as Label
export(NodePath) onready var synopsis_node = get_node(synopsis_node) as Label
export(NodePath) onready var technical_node = get_node(technical_node) as Label
export(NodePath) onready var count_node = get_node(count_node) as Label
export(NodePath) onready var vignette_node = get_node(vignette_node) as TextureRect

func setup(game_data_resource):
	title_node.text = game_data_resource.game_name
	synopsis_node.text = game_data_resource.game_synopsis
	technical_node.text = game_data_resource.game_technical_info
	count_node.text = game_data_resource.player_count
	vignette_node.texture = game_data_resource.vignette

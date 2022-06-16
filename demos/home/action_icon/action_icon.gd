extends HBoxContainer

onready var action_display_icon = $ActionIcon
onready var action_display_name : Label = $ActionName
onready var animation_player = $AnimationPlayer
export(Resource) var main_sfx_manager

signal appeared

func _ready():
	modulate.a = 0

func appear():
	main_sfx_manager.play("pop")
	animation_player.play("pop")
	yield(animation_player, "animation_finished")
	emit_signal("appeared")
	
func setup(icon_texture : Texture, action_name : String, font_color : Color = Color.black):
	action_display_name.text = action_name.to_upper()
	action_display_name.set("custom_colors/font_color", font_color)
	action_display_icon.texture = icon_texture


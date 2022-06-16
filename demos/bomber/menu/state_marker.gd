extends PanelContainer

onready var label = $Margin/Text
func _ready():
	set("custom_styles/panel", get("custom_styles/panel").duplicate())

func set_state(text : String, bg_color : Color):
	var style = get("custom_styles/panel")
	var past_color = style.get_bg_color()
	$Tween.interpolate_property(style, "bg_color", past_color, bg_color, 0.2)
	$Tween.start()
	label.text = text
	

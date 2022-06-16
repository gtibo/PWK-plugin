extends Resource
class_name focus_manager

export(Resource) var story_manager

signal focus(action_name)
signal defocus

var current_zone_name = null

func focus(zone_name):
	var action_data = story_manager.get_action_data(zone_name)
	if action_data.has("condition"):
		var variable_name : String = action_data.condition
		var is_negative = variable_name.left(1) == "!"
		if is_negative:
			variable_name = variable_name.trim_prefix("!")
		var variable_value : bool = story_manager.get_variable(variable_name)
		# Ugly
		var cancel_focus = !variable_value
		if is_negative:
			cancel_focus = variable_value
		if cancel_focus: return
	current_zone_name = zone_name
	emit_signal("focus", action_data.name)

func defocus(zone_name):
	if current_zone_name != zone_name: return
	current_zone_name = null
	emit_signal("defocus")

func request_action():
	if current_zone_name == null: return
	story_manager.read_action(current_zone_name)

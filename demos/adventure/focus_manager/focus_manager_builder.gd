extends Resource
class_name focus_manager

export(Resource) var story_manager

signal focus(action_name)
signal defocus

var current_zone_name = null

func focus(zone_name):
	current_zone_name = zone_name
	emit_signal("focus", story_manager.get_action_data(zone_name).name)

func defocus(zone_name):
	if current_zone_name != zone_name: return
	current_zone_name = null
	emit_signal("defocus")

func request_action():
	if current_zone_name == null: return
	story_manager.read_action(current_zone_name)

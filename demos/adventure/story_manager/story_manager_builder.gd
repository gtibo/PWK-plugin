extends Resource
class_name StoryManager

export(String, FILE, "*.json") var story_data_path

var story_data = {}
var current_location = null

signal action_started
signal action_ended
signal location_change(to, landmark)
signal custom_signal(name, value)
signal play_stack(stack)

func setup():
	var file = File.new()
	file.open(story_data_path, file.READ)
	var text = file.get_as_text()
	story_data = JSON.parse(text).result
	file.close()
	current_location = story_data.start

func get_variable(variable_name):
	return story_data.variables[variable_name]
	
func set_variable(variable_name, new_value):
	story_data.variables[variable_name] = new_value
	
func location_data():
	return story_data.locations[current_location]

func get_action_data(zone_name):
	return location_data()["actions"][zone_name]
	
func read_event(node, event_name):
	var event_data = story_data.locations[current_location]["events"][event_name]
	if event_data.once:
		node.queue_free()
	var stack = event_data.stack
	emit_signal("play_stack", stack)

func change_location(location_name, landmark):
	emit_signal("location_change", location_name, landmark)
	
func read_action(current_zone_name):
	emit_signal("action_started")
	var stack = get_action_data(current_zone_name).stack
	emit_signal("play_stack", stack)

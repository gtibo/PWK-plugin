extends Resource
class_name StoryManager

export(String, FILE, "*.json") var story_data_path
export(Resource) var dialogue_manager
export(Array, Resource) var known_actors

var story_data = {}
var current_location = null

signal location_change(to, landmark)
signal custom_signal(name, value)

func setup():
	var file = File.new()
	file.open(story_data_path, file.READ)
	var text = file.get_as_text()
	file.close()
	story_data = JSON.parse(text).result
	current_location = story_data.start
	var actor_table = {}
	for actor in known_actors:
		actor_table[actor.id] = actor
	known_actors = actor_table

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
	play_stack(stack)

func change_location(location_name, landmark):
	emit_signal("location_change", location_name, landmark)
	
func read_action(current_zone_name):
	var stack = get_action_data(current_zone_name).stack
	play_stack(stack)
	
func play_stack(stack):
	var step_id = "0"
	while true:
		var step = stack[step_id]
		match step.type:
			"dialogue":
				dialogue_manager.start(step.name)
				yield(dialogue_manager, "dialogue_end")
			"set":
				set_variable(step.variable, step.value)
			"emit":
				emit_signal("custom_signal", step.name, step.value)
			"location_change":
				change_location(step.to, step.landmark)
		if not step.has("next"): break
		
		if step.type == "condition":
			var bool_str = ["negative", "positive"]
			var variable_value = get_variable(step.variable)
			var condition_value = bool_str[int(variable_value)]
			step_id = step.next[condition_value]
		else:
			step_id = step.next

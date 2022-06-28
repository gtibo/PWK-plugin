extends Resource
class_name StoryManager

export(String, FILE, "*.json") var story_data_path
export(Resource) var dialogue_manager
export(Resource) var mini_game_manager
export(Resource) var navigation_manager
export(Resource) var actor_manager

var story_data = {}
var current_location = null

signal action_started
signal action_ended

signal location_change(to, landmark)
signal custom_signal(name, value)

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
	play_stack(stack)

func change_location(location_name, landmark):
	emit_signal("location_change", location_name, landmark)
	
func read_action(current_zone_name):
	emit_signal("action_started")
	var stack = get_action_data(current_zone_name).stack
	play_stack(stack.duplicate(true))
	
func play_stack(stack):
	emit_signal("action_started")
	var step_id = "0"
	var memory_data = {}
	while true:
		var step = stack[step_id]
		match step.type:
			"dialogue":
				dialogue_manager.start(step.name)
				var returnedValue = yield(dialogue_manager, "dialogue_end")
				if step.has("onReturn") && returnedValue:
					step.next = step.onReturn[returnedValue]
			"minigame":
				mini_game_manager.start(step.name)
				var score = yield(mini_game_manager, "game_end")
				memory_data["step_" + step_id + "_score"] = score
			"compare":
				var a_value = is_step_data(step.a, memory_data)
				var b_value = is_step_data(step.b, memory_data)
				var res_bool = evalutate_compare_method(step.method, a_value, b_value)
				var bool_str = ["negative", "positive"]
				var condition_value = bool_str[int(res_bool)]
				step.next = step[condition_value]
			"goto":
				navigation_manager.walk_to(step.routes)
				yield(navigation_manager, "everyone_walked_to")
			"lookat":
				for look in step.looks:
					var actor = actor_manager.get_actor(look[0]).anchor
					var actor_target = actor_manager.get_actor(look[1]).anchor
					actor.look(actor_target.global_transform.origin)
			"set":
				set_variable(step.variable, step.value)
			"emit":
				emit_signal("custom_signal", step.name)
			"location_change":
				current_location = step.to
				change_location(step.to, step.landmark)
		# Check default next
		if not step.has("next"): break
		if step.type == "condition":
			var bool_str = ["negative", "positive"]
			var variable_value = get_variable(step.variable)
			var condition_value = bool_str[int(variable_value)]
			step_id = step.next[condition_value]
		else:
			step_id = step.next

	emit_signal("action_ended")
	
func is_step_data(value, memory_data):
	if value is String:
		return memory_data[value]
	else:
		return value

func evalutate_compare_method(method_name, a, b):
	match method_name:
		"A_GREATER_THAN_B":
			return a > b

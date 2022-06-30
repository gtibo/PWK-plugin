extends Node

export(Resource) var story_manager
export(Resource) var dialogue_manager
export(Resource) var mini_game_manager
export(Resource) var navigation_manager
export(Resource) var actor_manager

func _ready():
	story_manager.connect("play_stack", self, "on_play_stack")

func on_play_stack(stack):
	story_manager.emit_signal("action_started")
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
				story_manager.set_variable(step.variable, step.value)
			"emit":
				story_manager.emit_signal("custom_signal", step.name)
			"location_change":
				story_manager.current_location = step.to
				story_manager.change_location(step.to, step.landmark)
		# Check default next
		if not step.has("next"): break
		if step.type == "condition":
			var bool_str = ["negative", "positive"]
			var variable_value = story_manager.get_variable(step.variable)
			var condition_value = bool_str[int(variable_value)]
			step_id = step.next[condition_value]
		else:
			step_id = step.next
	story_manager.emit_signal("action_ended")
	
func is_step_data(value, memory_data):
	if value is String:
		return memory_data[value]
	else:
		return value

func evalutate_compare_method(method_name, a, b):
	match method_name:
		"A_GREATER_THAN_B":
			return a > b

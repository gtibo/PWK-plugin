extends Resource
class_name ActorManager
var known_actors = {}

func set_known_actors(new_known_actors):
	known_actors = new_known_actors

func get_actor(actor_name):
	return known_actors[actor_name]

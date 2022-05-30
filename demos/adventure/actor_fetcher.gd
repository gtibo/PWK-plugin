extends Node

export(Array, Resource) var known_actors
export(Resource) var actor_manager

func _ready():
	var actor_table = {}
	for actor in known_actors:
		actor_table[actor.id] = actor
	actor_manager.set_known_actors(actor_table)

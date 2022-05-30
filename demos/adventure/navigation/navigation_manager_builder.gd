extends Resource
class_name NavigationManager

export(Resource) var actor_manager
export(Resource) var landmark_manager

var current : Navigation = null

# Emit when every nodes walked to their destination...
signal everyone_walked_to

var walkers = []

func set_current(new_navigation):
	current = new_navigation

func walk_to(routes):
	for route in routes:
		var actor = actor_manager.get_actor(route[0])
		var anchor = actor.anchor
		walkers.append(actor.anchor)
		var landmark = landmark_manager.get_landmark(route[1]).get_position()
		var path = current.get_simple_path(anchor.translation, landmark)
		anchor.connect("walked_to", self, "on_actor_walked_to", [actor.anchor])
		anchor.walk_to(path)

func on_actor_walked_to(actor):
	actor.disconnect("walked_to", self, "on_actor_walked_to")
	walkers.erase(actor)
	if walkers.size() == 0:
		emit_signal("everyone_walked_to")

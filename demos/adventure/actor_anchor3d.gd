extends Spatial
export(Resource) var current_actor

func _ready():
	if current_actor == null: return
	current_actor.anchor = self

func get_screen_position():
	return get_viewport().get_camera().unproject_position(global_transform.origin)

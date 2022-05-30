extends Position3D

export(String) var landmark_name = ""

func _ready():
	add_to_group("landmark")

func get_position():
	return global_transform.origin

extends Resource
class_name ActorData

export(String) var id
export(String) var name
var anchor = null setget set_anchor, get_anchor

func get_anchor():
	return anchor

func set_anchor(v):
	anchor = v

extends Area2D
class_name HitZone
var emitter = null

func _init(p = null, pos = Vector2.ZERO):
	emitter = p
	self.position = pos
	
func is_emitter(p):
	return p == emitter
	
func _ready():
	for i in range(3):
		yield(get_tree(), "physics_frame")
	queue_free()

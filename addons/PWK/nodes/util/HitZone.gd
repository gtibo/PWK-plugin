extends Area2D
class_name HitZone
var emitter = null

func setup(p = null, pos = Vector2.ZERO, power = 1):
	emitter = p
	self.position = pos
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius *= (1.0 + power) / 2.0
	
func is_emitter(p):
	return p == emitter
	
func _ready():
	for i in range(3):
		yield(get_tree(), "physics_frame")
	queue_free()

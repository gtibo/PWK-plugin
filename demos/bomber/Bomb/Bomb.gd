extends KinematicBody2D

var velocity = Vector2.ZERO
const TOP_SPEED = 1200.0
const FRICTION = 10
export(Resource) var RuleManager

func setup(spawn_power = null, spawn_pos = null, spawn_vel = null):
	if spawn_pos:
		position = spawn_pos
	if spawn_vel:
		velocity = spawn_vel * TOP_SPEED
	if spawn_power:
		$Timer.wait_time = 1 + spawn_power * 2
		#scale = Vector2(spawn_power,spawn_power)

func _ready():
	$Timer.start()
	
func _physics_process(delta):
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, FRICTION * delta)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION * .1 * delta)
	velocity.y += 1200 * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)
	velocity = velocity.clamped(TOP_SPEED)

func _on_HitBox_area_entered(area):
	if area is HitZone:
		var angle = 0
		if self.position.x > area.position.x: angle = 1
		else:  angle = -1
		var force = Vector2(angle * 10, -10) * 100
		velocity += force
		return

func _on_Timer_timeout():
	RuleManager.explode(position)
	queue_free()

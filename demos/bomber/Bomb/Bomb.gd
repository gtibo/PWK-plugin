extends KinematicBody2D

var velocity = Vector2.ZERO
const TOP_SPEED = 1200.0
const FRICTION = 10
export(Resource) var RuleManager
export(Resource) var main_positional_sfx_manager

var power = 1

func setup(spawn_power = null, spawn_pos = null, spawn_vel = null):
	power = spawn_power
	if spawn_pos:
		position = spawn_pos
	if spawn_vel:
		velocity = spawn_vel * TOP_SPEED
	if spawn_power:
		$Timer.wait_time = 1 + spawn_power * 2
		$Sprite.scale = $Sprite.scale * (1.0 + spawn_power)
		

func _ready():
	$Timer.start()
	
func _process(delta):
	var diff = ($Timer.time_left / $Timer.wait_time)
	
	var t = OS.get_ticks_msec() * 0.02
	var s = lerp(range_lerp(sin(t), -1.0, 1.0, 0.5, 1.2), 1.0, diff)
	var color = lerp(Color.orangered, Color.white, lerp(range_lerp(sin(t), -1.0, 1.0, 0.0, 1.0), 1.0, diff))
	modulate = color
	scale = Vector2(s,s)
	
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
	main_positional_sfx_manager.play("explosion", global_position)
	RuleManager.explode(position, power)
	queue_free()

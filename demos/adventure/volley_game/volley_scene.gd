extends Node

export(Resource) var landmark_manager
export(Resource) var actor_manager
export(Resource) var camera_manager

signal ended(score)

var player
var opponent
var opponent_area : Area
var player_area
var player_score = 0
var opponent_score = 0

onready var opponent_zone = $TerrainRoot/OpponentZone
onready var player_zone = $TerrainRoot/PlayerZone

onready var opponent_counter = $CanvasLayer/MarginContainer/OpponentCounter
onready var player_counter = $CanvasLayer/MarginContainer/PlayerCounter

var max_score = 3

var full_throw_time = 1000
var start_focus = null

var desired_position = Vector3.ZERO
var ball_next_destination = null

export(PackedScene) var ball_scene
var ball_instance

func _unhandled_input(event):
	if $PunchTimer.time_left != 0: return
	if Input.is_action_just_pressed("0_a_button"):
		$TerrainRoot/desiredTarget.show()
		start_focus = OS.get_ticks_msec()
		desired_position = Vector3.ZERO
	
	if start_focus == null: return
	
	if Input.is_action_just_released("0_a_button"):
		$TerrainRoot/desiredTarget.hide()
		start_focus = null
	
		var area = Area.new()
		var collision = CollisionShape.new()
		collision.shape = SphereShape.new()
		collision.shape.radius = .5
		area.add_child(collision)
		area.translation = $TerrainRoot.to_local(player.translation)
		area.translation.y = 1
		$TerrainRoot.add_child(area)
		desired_position.z *= rand_range(.5,1.5)
		desired_position.z = clamp(desired_position.z, -1, 1)
		area.connect("body_entered", self, "ball_entered_player", [desired_position])
		$PunchTimer.start()
		yield($PunchTimer, "timeout")
		area.queue_free()
	
func ball_entered_player(body, destination):
	if !body.is_in_group("Ball"): return
	throw_ball_at(destination)
	ball_next_destination = destination
	var supposed_destination = Vector3(destination.x * rand_range(.5,1.5), 0, destination.y * rand_range(.5,1.5))
	supposed_destination.x = clamp(supposed_destination.x,-1,-2)
	supposed_destination.z = clamp(supposed_destination.z,-1,1)
	opponent.walk_to([$TerrainRoot.to_global(supposed_destination)])

func _physics_process(delta):
	if start_focus == null: return
	var now = OS.get_ticks_msec()
	var diff = min(full_throw_time, now - start_focus)
	desired_position.x = range_lerp(diff, 0, full_throw_time, -1, -3)
	desired_position.z = $TerrainRoot.to_local(player.translation).z
	
	$TerrainRoot/desiredTarget.translation = desired_position
	
func _ready():
	randomize()
	var landmark = landmark_manager.get_landmark("VolleyBallTerrain")
	$TerrainRoot.translation = landmark.get_position()
	player = actor_manager.get_actor("m.hat").anchor
	opponent = actor_manager.get_actor("jp").anchor
	player.unlock()
	
	opponent_area = Area.new()
	var collision = CollisionShape.new()
	collision.shape = SphereShape.new()
	collision.shape.radius = 0.25
	opponent_area.translation.y = 0.5
	opponent_area.add_child(collision)
	opponent.add_child(opponent_area)
	opponent_area.connect("body_entered", self, "ball_enter_opponent")
	$TerrainRoot/desiredTarget.hide()
	
	ball_instance = ball_scene.instance()
	
	
	opponent_counter.set_point(0)
	player_counter.set_point(0)

	camera_manager.change_camera("VolleyCamera")
	yield(camera_manager, "camera_changed")
	
	serve_ball()
	
func ball_enter_opponent(body):
	if !body.is_in_group("Ball"): return
	throw_ball_at(Vector3(rand_range(1,2), 0, rand_range(-1,1)))
	
func throw_ball_at(target : Vector3):
	ball_instance.angular_velocity = Vector3.ZERO
	ball_instance.linear_velocity = Vector3.ZERO
	var angle = null
	var strength = 1
	while angle == null:
		angle = balistic_arc(ball_instance.translation, strength * 1.1, target, 9.8)
		strength += 2
	ball_instance.apply_central_impulse(angle)
	ball_instance.apply_torque_impulse(angle * .01)

# Adapted from: 
# https://www.forrestthewoods.com/blog/solving_ballistic_trajectories/

func balistic_arc(proj_pos : Vector3, proj_speed : float, target : Vector3, gravity : float):
	var s0 = Vector3.ZERO
	var s1 = Vector3.ZERO
	var diff : Vector3 = target - proj_pos
	var diffXZ : Vector3 = Vector3(diff.x, 0.0, diff.z)
	var groundDist = diffXZ.length()

	var speed2 : float = proj_speed*proj_speed;
	var speed4 : float = proj_speed*proj_speed*proj_speed*proj_speed;
	var y : float = diff.y;
	var x : float = groundDist;
	var gx : float = gravity*x;

	var root : float = speed4 - gravity*(gravity*x*x + 2*y*speed2);

	# No solution
	if root < 0:
		return null

	root = sqrt(root)

	var lowAng : float = atan2(speed2 - root, gx);
	var highAng : float = atan2(speed2 + root, gx);

	var groundDir : Vector3 = diffXZ.normalized()
	if lowAng == highAng:
		return null
		#return groundDir * cos(lowAng) * proj_speed + Vector3.UP * sin(lowAng) * proj_speed
	else:
		return groundDir * cos(highAng) * proj_speed + Vector3.UP * sin(highAng) * proj_speed

func _on_Sight_body_entered(body):
	if ball_next_destination == null:
		return
	if !body.is_in_group("Ball"): return
	opponent.walk_to([$TerrainRoot.to_global(ball_next_destination)])

func serve_ball():
	$TerrainRoot.add_child(ball_instance)
	ball_instance.angular_velocity = Vector3.ZERO
	ball_instance.linear_velocity = Vector3.ZERO
	ball_instance.translation = $TerrainRoot.to_local(opponent.global_transform.origin)
	ball_instance.translation.y += 2
	
func _on_OpponentZone_body_entered(body):
	if !body.is_in_group("Ball"):
		return
	player_score += 1
	player_counter.set_point(player_score)
	relaunch_loop()
	
func _on_PlayerZone_body_entered(body):
	if !body.is_in_group("Ball"):
		return
	opponent_score += 1
	opponent_counter.set_point(opponent_score)
	relaunch_loop()
	
func relaunch_loop():
	opponent_zone.set_deferred("monitoring", false)
	player_zone.set_deferred("monitoring", false)
	opponent_area.set_deferred("monitoring", false)
	$Timer.start()
	yield($Timer, "timeout")
	remove_ball()
	if opponent_score >= max_score || player_score >= max_score:
		end_game(player_score > opponent_score)
		return
	opponent.walk_to([$TerrainRoot.to_global(Vector3(-1.5, 0, 0))])
	yield(opponent, "walked_to")
	opponent_zone.set_deferred("monitoring", true)
	player_zone.set_deferred("monitoring", true)
	opponent_area.set_deferred("monitoring", true)
	serve_ball()
	
func remove_ball():
	$TerrainRoot.remove_child(ball_instance)
	
func end_game(victory):
	camera_manager.change_camera("PlayerCamera")
	opponent.remove_child(opponent_area)
	emit_signal("ended", victory)

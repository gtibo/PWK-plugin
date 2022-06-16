extends PlatformerController
var hit_container
export(NodePath) onready var punch_timer = get_node(punch_timer)
export(NodePath) onready var bomb_timer = get_node(bomb_timer)
export(Resource) var RuleManager
export(Resource) var main_sfx_manager
export(PackedScene) var punch_scene
export(PackedScene) var bomb_scene

var punch_button
var bomb_button
var run_button

var can_throw_bomb = true
var can_punch = true

signal changeDirection
signal punch

var direction = 0

func setup(spawn_pos = null, ctrl_index = null):
	if spawn_pos:
		position = spawn_pos
	if ctrl_index != null:
		set_controller_index(ctrl_index)

func set_controller_index(ctrl_index):
	.set_controller_index(ctrl_index)
	punch_button = str(controller_index) + "_b_button"
	bomb_button = str(controller_index) + "_x_button"
	run_button = str(controller_index) + "_l_button"
	
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("stroke_color", RuleManager.themes[ctrl_index].stroke)
	$Sprite.material.set_shader_param("main_color", RuleManager.themes[ctrl_index].main)
	$Sprite.material.set_shader_param("second_color", RuleManager.themes[ctrl_index].second)
	
func _ready():
	RuleManager.connect("victory", self, "on_victory")

func get_speed_boost(percent):
	return 1 + int(Input.is_action_pressed(run_button)) * percent

func check_direction():
	if x_input != direction:
		direction = x_input
		emit_signal("changeDirection", direction)
		
func apply_x_inputs(delta):
	if x_input == 0: return
	check_direction()
	var air_slowdown = 1.0
	if !is_on_floor():
		air_slowdown = 0.5
	velocity.x = lerp(velocity.x, x_input * (SPEED * get_speed_boost(1.0)), acceleration * air_slowdown * delta)
	
func check_punch():
	if Input.is_action_just_pressed(punch_button) && can_punch:
		RuleManager.player_action_update(self, "can_punch", false)
		can_punch = false
		RuleManager.request_punch(self)
		punch_timer.start()
		emit_signal("punch")
		
func check_throw():
	if Input.is_action_pressed(bomb_button) && can_throw_bomb:
		$StateMachine.transition_to("Throw")
		
func throw_bomb(power):
	RuleManager.player_action_update(self, "can_throw_bomb", false)
	can_throw_bomb = false
	bomb_timer.start()
	var spawn_vel = Vector2(power * x_input, -power)
	RuleManager.request_bomb(self, power, spawn_vel)
	
func _on_HitBox_area_entered(area):
	if area is HitZone and not area.is_emitter(self):
		main_sfx_manager.play("hit")
		snap_vector = Vector2.ZERO
		var angle = 0
		if self.position.x > area.position.x: angle = 1
		else:  angle = -1
		var force = Vector2(angle * 10, -10) * 100
		velocity += force
		$StateMachine.transition_to("Stunned")
		# Input.start_joy_vibration(controller_index,0,1,.4)
		return
	if area.is_in_group("KO"):
		$StateMachine.transition_to("KO")
		RuleManager.player_ko(self)
		return

func on_victory(player):
	if self == player:
		$StateMachine.transition_to("Dance")

func _on_Punch_timer_timeout():
	can_punch = true
	RuleManager.player_action_update(self, "can_punch", true)
	
func _on_Bomb_timer_timeout():
	can_throw_bomb = true
	RuleManager.player_action_update(self,"can_throw_bomb", true)

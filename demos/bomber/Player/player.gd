extends PlatformerController
var hit_container
export(NodePath) onready var punch_timer = get_node(punch_timer)
export(NodePath) onready var bomb_timer = get_node(bomb_timer)
export(Resource) var RuleManager
export(PackedScene) var punch_scene
export(PackedScene) var bomb_scene

onready var sprite = $Sprite

var punch_button
var bomb_button
var run_button

var can_throw_bomb = true
var can_punch = true

func setup(spawn_pos = null, ctrl_index = null):
	if spawn_pos:
		position = spawn_pos
	if ctrl_index != null:
		set_controller_index(ctrl_index)

func set_controller_index(ctrl_index):
	.set_controller_index(ctrl_index)
	punch_button = str(controller_index) + "_b_button"
	bomb_button = str(controller_index) + "_x_button"
	run_button = str(controller_index) + "_r2_button"

func _ready():
	RuleManager.connect("victory", self, "on_victory")

func _physics_process(delta):
	if x_input != 0:
		sprite.flip_h = x_input > 0

func get_speed_boost():
	return 1
	return 1 + int(Input.is_action_pressed(run_button)) * .2
	
func apply_x_inputs(delta):
	if x_input == 0: return
	velocity.x = lerp(velocity.x, x_input * (SPEED * get_speed_boost()), acceleration * delta)
	
func check_punch():
	if Input.is_action_just_pressed(punch_button) && can_punch:
		RuleManager.player_action_update(self, "can_punch", false)
		can_punch = false
		RuleManager.request_punch(self)
		punch_timer.start()

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
		var angle = 0
		if self.position.x > area.position.x: angle = 1
		else:  angle = -1
		var force = Vector2(angle * 10, -10) * 100
		velocity += force
		$StateMachine.transition_to("Stunned")
		Input.start_joy_vibration(controller_index,0,1,.4)
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


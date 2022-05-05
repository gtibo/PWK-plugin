extends CanvasLayer

export(Resource) var RuleManager
export(PackedScene) var PlayerMarker

var timers = []
var player_ready = []

signal selection_ok
var selection_locked = false
func _ready():
	RuleManager.player_info = []
	for i in range(4):
		var pm = PlayerMarker.instance()
		pm.set_theme(RuleManager.themes[i])
		$MenuScreen/HBoxContainer.add_child(pm)
		pm.hide()
		var t = pm.ready_timer
		t.one_shot = true
		t.connect("timeout", self, "player_ready", [i])
		timers.append(pm)
		
func player_joined(i):
	if !RuleManager.has_player_info(i):
		RuleManager.add_player_info(i)
	timers[i].ready_timer.start()
	timers[i].show()
	timers[i].set_label(.2)
	
func player_left(i):
	if RuleManager.has_player_info(i):
		RuleManager.remove_player_info(i)
	timers[i].hide()
	
func player_ready(i):
	timers[i].set_label(1)
	if !player_ready.has(i):
		player_ready.append(i)
	if player_ready.size() >= 2 && player_ready.size() == RuleManager.player_info.size():
		emit_signal("selection_ok")
		selection_locked = true

func player_not_ready(i):
	timers[i].ready_timer.stop()
	timers[i].set_label(.2)
	if player_ready.has(i):
		player_ready.erase(i)

func _input(event):
	if selection_locked: return
	for i in range(3):
		if Input.is_action_just_pressed(str(i)+"_a_button"):
			player_joined(i)
			
		if Input.is_action_just_released(str(i)+"_a_button"):
			player_not_ready(i)
			
		if !Input.is_action_pressed(str(i)+"_a_button") && Input.is_action_just_pressed(str(i)+"_b_button"):
			player_left(i)

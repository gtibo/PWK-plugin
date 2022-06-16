extends CanvasLayer

export(Resource) var rule_manager
export(PackedScene) var player_marker_scene

export(NodePath) onready var player_display = get_node(player_display) as HBoxContainer

var player_markers = []
var player_ready = []
var selection_locked = false

signal selection_ok

func _ready():
	rule_manager.player_info = []
	for i in range(4):
		var player_marker = player_marker_scene.instance()
		player_display.add_child(player_marker)
		player_marker.set_inactive()
		player_marker.set_theme(rule_manager.themes[i])
		var t = player_marker.ready_timer
		t.one_shot = true
		t.connect("timeout", self, "player_ready", [i])
		player_markers.append(player_marker)
		
func player_joined(i):
	if !rule_manager.has_player_info(i):
		rule_manager.add_player_info(i)
	player_markers[i].ready_timer.start()
	player_markers[i].set_not_ready()
	
func player_left(i):
	if rule_manager.has_player_info(i):
		rule_manager.remove_player_info(i)
	player_markers[i].set_inactive()
	
func player_ready(i):
	if !player_ready.has(i):
		player_ready.append(i)
	player_markers[i].set_ready()
	if player_ready.size() >= 2 && player_ready.size() == rule_manager.player_info.size():
		emit_signal("selection_ok")
		selection_locked = true

func player_not_ready(i):
	player_markers[i].ready_timer.stop()
	if player_ready.has(i):
		player_ready.erase(i)
	player_markers[i].set_not_ready()
	
func _input(event):
	if selection_locked: return
	for i in range(3):
		if Input.is_action_just_pressed(str(i)+"_a_button"):
			player_joined(i)
			
		if Input.is_action_just_released(str(i)+"_a_button"):
			player_not_ready(i)
			
		if !Input.is_action_pressed(str(i)+"_a_button") && Input.is_action_just_pressed(str(i)+"_b_button"):
			player_left(i)

extends MarginContainer
export(NodePath) onready var action_name_label = get_node(action_name_label) as Label
export(Resource) var main_focus_manager
export(Resource) var story_manager

var active = true

func _unhandled_input(_event):
	if !active: return
	if Input.is_action_just_pressed("0_a_button"):
		main_focus_manager.request_action()
		
func _ready():
	story_manager.connect("action_started", self, "desactivate")
	story_manager.connect("action_ended", self, "activate")
	main_focus_manager.connect("focus", self, "on_focus")
	main_focus_manager.connect("defocus", self, "on_defocus")
	$AnimationPlayer.play_backwards("open")
	
func activate():
	active = true
	if main_focus_manager.current_zone_name == null: return
	$AnimationPlayer.play("open")
	
func desactivate():
	active = false
	if main_focus_manager.current_zone_name == null: return
	$AnimationPlayer.play_backwards("open")
	
func on_focus(zone_name):
	action_name_label.text = zone_name
	if !active: return
	$AnimationPlayer.play("open")
	
func on_defocus():
	if !active: return
	$AnimationPlayer.play_backwards("open")
	
func _on_FocusViewer_resized():
	check_size()

func check_size():
	var w = rect_size.x
	var h = rect_size.y
	var ratio
	if w > h:
		ratio = Vector2(1,w/h)
	else:
		ratio = Vector2(h/w,1)
	$Bubble.material.set_shader_param("ratio", ratio)
	
	rect_pivot_offset = rect_size / 2

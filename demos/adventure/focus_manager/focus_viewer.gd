extends PanelContainer
export(NodePath) onready var action_name_label = get_node(action_name_label) as Label
export(Resource) var main_focus_manager
export(Resource) var dialogue_manager

var active = true

func _unhandled_input(_event):
	if !active: return
	if Input.is_action_just_pressed("0_a_button"):
		main_focus_manager.request_action()
func _ready():
	dialogue_manager.connect("dialogue_start", self, "desactivate")
	dialogue_manager.connect("dialogue_end", self, "activate")
	main_focus_manager.connect("focus", self, "on_focus")
	main_focus_manager.connect("defocus", self, "on_defocus")
	hide()

func activate():
	active = true
	if main_focus_manager.current_zone_name == null: return
	show()
	
func desactivate():
	hide()
	active = false
	
func on_focus(zone_name):
	show()
	action_name_label.text = zone_name
	
func on_defocus():
	hide()
	action_name_label.text = ""
	

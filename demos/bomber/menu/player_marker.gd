extends VBoxContainer

onready var ready_timer = $Timer
onready var head = $AspectRatioContainer/HeadSprite
onready var state_marker = $HBoxContainer/StateMarker

onready var join_label = $HBoxContainer/Info/JoinLabel
# onready var leave_label = $leaveLabel
onready var hold_label = $HBoxContainer/Info/holdLabel

func _ready():
	join_label.hide()
	#leave_label.hide()
	hold_label.hide()

func set_theme(t):
	head.set_theme(t)
	
func set_inactive():
	head.set_state("sleep")
	state_marker.set_state("Sleeping", Color(0,0,0,0.8))
	join_label.show()
	hold_label.hide()
	
func set_not_ready():
	head.set_state("smile")
	state_marker.set_state("Waiting...", Color("FFB13D"))
	join_label.hide()
	hold_label.show()

func set_ready():
	state_marker.set_state("Ready!", Color("29C84C"))
	hold_label.hide()
	join_label.hide()

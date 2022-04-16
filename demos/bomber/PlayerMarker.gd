extends VBoxContainer

onready var ready_timer = $Timer

func set_label(value):
	$Label.text = value

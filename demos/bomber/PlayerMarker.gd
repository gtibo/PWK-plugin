extends VBoxContainer

onready var ready_timer = $Timer

func set_theme(t):
	$Head.modulate = t.fill
	
func set_label(alpha):
	$ReadyState.modulate.a = alpha

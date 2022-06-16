extends Control

export(Resource) var RuleManager
export(Resource) var main_sfx_manager

signal announcer_end

func _ready():
	RuleManager.connect("victory", self, "on_victory")
	hide()
	
func on_victory(player):
	main_sfx_manager.play("won")
	show()
	$Label.rect_pivot_offset = $Label.rect_size / 2.0
	$Particles.emitting = true
	$AnimationTree.active = true
	var size = get_viewport().size
	$Particles.position = size / 2.0
	$Label.text = RuleManager.themes[player.controller_index].name + " wins!!!"
	$Timer.start()
	yield($Timer, "timeout")
	emit_signal("announcer_end")

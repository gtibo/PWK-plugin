extends State

func enter(msg := {}) -> void:
	owner.walk_tween.remove_all()
	owner.animation.play("walk")
	for pos in msg.list:
		var dist = owner.translation.distance_to(pos)
		var time = dist / owner.max_speed
		var end_translation = pos
		end_translation.y = owner.translation.y
		owner.look(end_translation)
		owner.walk_tween.interpolate_property(owner, "translation", owner.translation, end_translation, time)
		owner.walk_tween.start()
		yield(owner.walk_tween, "tween_completed")
	owner.emit_signal("walked_to")
	state_machine.transition_to("Idle")

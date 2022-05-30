extends State

func enter(_msg := {}) -> void:
	owner.animation.play("idle")

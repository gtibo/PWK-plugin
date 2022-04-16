extends PlatformerStateRun

func physics_update(delta) -> void:
	.physics_update(delta)
	owner.check_punch()
	owner.check_throw()
	owner.sprite.play("Run")

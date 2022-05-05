extends PlatformerStateIdle

func physics_update(delta) -> void:
	.physics_update(delta)
	owner.check_punch()
	owner.check_throw()

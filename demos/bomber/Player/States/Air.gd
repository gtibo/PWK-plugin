extends PlatformerStateAir

func enter(_msg := {}) -> void:
	owner.snap_vector = Vector2.ZERO
	if _msg.has("do_jump"):
		owner.velocity.y = -owner.SPEED * owner.get_speed_boost() * 2
	owner.sprite.play("Jump")

func physics_update(delta) -> void:
	.physics_update(delta)
	if owner.is_on_wall() && owner.x_input != 0:
		state_machine.transition_to("Slide")
	owner.check_punch()
	owner.sprite.play("Jump")

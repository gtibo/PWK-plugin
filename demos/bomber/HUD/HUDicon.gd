extends AnimatedSprite

onready var animation_player = $AnimationPlayer
onready var tween = $Tween

onready var original_scale = scale
onready var small_scale = original_scale * 0.5

func set_state(value):
	tween.reset_all()
	if value:
		animation_player.play("Shake")
		tween.interpolate_method(self, "grow", 0, 1, 0.6, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	else:
		tween.interpolate_method(self, "shrink", 0, 1, 0.6, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func shrink(step):
	scale = lerp(original_scale, small_scale, step)
	modulate.a = lerp(1.0, 0.4, step)

func grow(step):
	scale = lerp(small_scale, original_scale, step)
	modulate.a = lerp(0.4, 1.0, step)

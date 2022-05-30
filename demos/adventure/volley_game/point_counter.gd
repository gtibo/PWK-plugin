extends TextureRect

func set_point(value):
	$AnimationPlayer.play(str(value))

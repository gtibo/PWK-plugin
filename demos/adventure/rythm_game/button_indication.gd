extends TextureRect

func miss():
	$AnimationPlayer.play("shake")

func hit():
	$AnimationPlayer.play("success")

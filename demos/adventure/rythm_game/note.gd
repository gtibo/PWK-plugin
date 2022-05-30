extends TextureRect

var time_start = 0

func setup():
	rect_pivot_offset = rect_size/2
	$AnimationPlayer.play("shake")

func touche():
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
func interpolate(start, end, speed):
	var now = OS.get_ticks_msec()
	var diff = (now - time_start) / speed
	rect_global_position = lerp(start, end, diff)
	return diff > 1.0

func out():
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

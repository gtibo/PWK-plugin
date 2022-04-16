extends Node2D

export(PackedScene) var InGameScene

	
func switch_scene(scene):
	if $SceneHolder.get_child_count() > 0:
		$Transition/AnimationPlayer.play("Open")
		yield($Transition/AnimationPlayer, "animation_finished")
		for child in $SceneHolder.get_children():
			child.queue_free()
	
	$SceneHolder.add_child(scene)
	
	$Transition/AnimationPlayer.play_backwards("Open")
	yield($Transition/AnimationPlayer, "animation_finished")
	

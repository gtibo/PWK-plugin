extends Spatial



func _on_Area_body_entered(body):
	$AnimationPlayer.play("shake")


func _on_Area_body_exited(body):
	$AnimationPlayer.play("shake")

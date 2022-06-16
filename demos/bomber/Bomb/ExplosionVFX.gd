extends Node2D

func setup(start_position, power):
	position = start_position
	$Sprite.scale *= (1.0 + (power * 1.2))

func _ready():
	$Sprite.play("default")
	$Sprite.play()
	
func _on_Sprite_animation_finished():
	queue_free()

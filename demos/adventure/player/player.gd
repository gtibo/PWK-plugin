extends TopDownController3D

onready var material : Material = $Sprite.material_override

export(Resource) var dialogue_manager

var busy = false

func _ready():
	dialogue_manager.connect("dialogue_start", self, "to_busy")
	dialogue_manager.connect("dialogue_end", self, "to_not_busy")

func to_busy():
	busy = true

func to_not_busy():
	busy = false

func _physics_process(delta):
	if busy:
		$AnimationPlayer.play("idle")
		$AudioStreamPlayer3D.desactivate()		
		return
	check_input()
	if input_vel.length() > 0:
		$AnimationPlayer.play("walk")
		$AudioStreamPlayer3D.activate()
		if input_vel.x > 0:
			material.set_shader_param("Flip", -1 )
		else:
			material.set_shader_param("Flip", 1 )
	else:
		$AnimationPlayer.play("idle")
		$AudioStreamPlayer3D.desactivate()
		
	check_movement(delta)

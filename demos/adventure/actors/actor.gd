extends KinematicBody
class_name KinematicActor

export(Resource) var actor_data 
onready var walk_tween : Tween = $walkTween
onready var animation : AnimationPlayer = $Animation
# export(NodePath) onready var mouth = get_node(mouth) as Spatial
export var max_speed = 2
var direction = 1

signal walked_to

func _ready():
	actor_data.set_anchor(self)
	move_and_collide(Vector3.ZERO)
	$Sprite.material_override = $Sprite.material_override.duplicate()
	
func get_screen_position():
	return get_viewport().get_camera().unproject_position(global_transform.origin)

func look(target):
	if(target.x < translation.x):
		set_direction(1)
	else:
		set_direction(-1)

func set_direction(value):
	direction = value
	$Sprite.material_override.set_shader_param("flip", value )

func walk_to(pos_list : PoolVector3Array):
	$StateMachine.transition_to("WalkTo", {"list":pos_list})

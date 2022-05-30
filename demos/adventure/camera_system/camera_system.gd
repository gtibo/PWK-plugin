extends Spatial

export(Resource) var camera_manager
onready var tween : Tween = $CameraTween
onready var t_camera : Camera = $TransitionCamera

var known_cameras = {}

var current_camera = null
var target_camera = null

func _ready():
	camera_manager.connect("camera_change_request", self, "on_camera_change_request")

func on_camera_change_request(target_camera_id):
	tween.remove_all()
	current_camera = get_viewport().get_camera()
	target_camera = known_cameras[target_camera_id]
	tween_camera(0)
	current_camera.current = false
	t_camera.current = true
	tween.interpolate_method(self, "tween_camera", 0, 1, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	t_camera.current = false
	target_camera.current = true
	
func fetch_cameras():
	var cameras = get_tree().get_nodes_in_group("camera")
	for camera in cameras:
		known_cameras[camera.name] = camera

func tween_camera(i):
	t_camera.translation = lerp(current_camera.global_transform.origin, target_camera.global_transform.origin, i)
	t_camera.fov = lerp(current_camera.fov, target_camera.fov, i)
	t_camera.rotation = lerp(current_camera.rotation, target_camera.rotation, i)

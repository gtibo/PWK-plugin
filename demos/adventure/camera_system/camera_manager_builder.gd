extends Resource
class_name CameraManager

signal camera_change_request(target_camera)

# Hold reference to the current camera
# BEWARE, must be set before any change!
var current_camera_id = null

func change_camera(target_camera_id):
	emit_signal("camera_change_request", target_camera_id)

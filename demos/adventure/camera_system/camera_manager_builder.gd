extends Resource
class_name CameraManager

signal camera_change_request(target_camera)
signal camera_changed

# Hold reference to the current camera
# BEWARE, must be set before any change!
var current_camera_id = null

func warn_camera_change():
	emit_signal("camera_changed")

func change_camera(target_camera_id):
	emit_signal("camera_change_request", target_camera_id)

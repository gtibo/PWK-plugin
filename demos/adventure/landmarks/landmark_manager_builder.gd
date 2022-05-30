extends Resource
class_name LandmarkManager

var landmarks = {}

func set_landmarks(new_landmarks):
	landmarks = new_landmarks
	
func get_landmark(landmark_name):
	return landmarks[landmark_name]

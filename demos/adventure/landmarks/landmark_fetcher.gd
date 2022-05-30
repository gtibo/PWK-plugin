extends Node
export(Resource) var landmark_manager

func _on_MainAdventure_location_changed():
	var landmarks = get_tree().get_nodes_in_group("landmark")
	var landmark_table = {}
	for landmark in landmarks:
		landmark_table[landmark.landmark_name] = landmark
	landmark_manager.set_landmarks(landmark_table)

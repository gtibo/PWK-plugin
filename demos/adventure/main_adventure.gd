extends Node
export(PackedScene) var player_scene
export(Resource) var story_manager
export(Array, Resource) var known_locations
# Should be equal to a vector
var player_spawn = null

func _ready():
	var location_table = {}
	for location in known_locations:
		location_table[location.name] = location.scene
	known_locations = location_table
	story_manager.setup()
	var spawn_name = story_manager.story_data.spawn
	load_scene(story_manager.story_data.start, spawn_name)
	story_manager.connect("location_change", self, "on_location_change")
	
func on_location_change(to, landmark):
	load_scene(to, landmark)
	
func load_scene(scene_name, spawn_name):
	if $SceneHolder.get_child_count() > 0:
		# Close animation
		$UI/Tween.interpolate_property($UI/TransitionRect.get_material(),
		"shader_param/opening", 1.0, 0.0, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
		$UI/Tween.start()
		yield($UI/Tween, "tween_completed")
		for child in $SceneHolder.get_children():
			child.queue_free()
				
	var scene = known_locations[scene_name].instance()
	$SceneHolder.add_child(scene)
	var landmarks = get_tree().get_nodes_in_group("landmark")
	var landmark_table = {}
	for landmark in landmarks:
		landmark_table[landmark.landmark_name] = landmark
	landmarks = landmark_table
	
	var spawn_position = landmarks[spawn_name].get_position()
	var player = player_scene.instance()
	player.translation = spawn_position
	$SceneHolder.add_child(player)
	# Open animation
	var m = $UI/TransitionRect.get_material()
	m.set_shader_param("opening", 0.0)
	$UI/Tween.interpolate_property(m,
	"shader_param/opening", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	$UI/Tween.start()

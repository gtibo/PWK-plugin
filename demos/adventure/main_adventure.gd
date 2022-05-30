extends Node
export(PackedScene) var player_scene
export(Resource) var story_manager
export(Array, Resource) var known_locations
export(Resource) var landmark_manager
export(Resource) var navigation_manager

signal location_changed

func _ready():
	var location_table = {}
	for location in known_locations:
		location_table[location.name] = location
	known_locations = location_table
	story_manager.setup()
	var spawn_name = story_manager.story_data.spawn
	load_scene(story_manager.story_data.start, spawn_name)
	story_manager.connect("location_change", self, "on_location_change")
	story_manager.connect("custom_signal", self, "on_custom_signal")
	
func on_custom_signal(signal_name, value):
	if signal_name == "restart":
		story_manager.setup()
		var spawn_name = story_manager.story_data.spawn
		load_scene(story_manager.story_data.start, spawn_name)

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
				
	var scene = known_locations[scene_name].scene.instance()
	$SoundTrack.stream = known_locations[scene_name].theme
	$SoundTrack.play()
	$SceneHolder.add_child(scene)
	# Scene set
	var player = player_scene.instance()
	$SceneHolder.add_child(player)
	emit_signal("location_changed")
	var spawn_position = landmark_manager.get_landmark(spawn_name).get_position()
	player.translation = spawn_position
	# Open animation
	var m = $UI/TransitionRect.get_material()
	m.set_shader_param("opening", 0.0)
	$UI/Tween.interpolate_property(m,
	"shader_param/opening", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	$UI/Tween.start()

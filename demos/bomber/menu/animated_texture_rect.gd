extends TextureRect

export(SpriteFrames) var sprite_frames : SpriteFrames

func _ready():
	var frame_count = sprite_frames.get_frame_count("default")
	var animation : Animation = Animation.new()
	animation.length = frame_count * 0.1
	animation.loop = true
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:texture")
	for frame_index in frame_count:
		var frame : Texture = sprite_frames.get_frame("default", frame_index)
		animation.track_insert_key(track_index, float(frame_index * 0.1), frame)
	var animation_player : AnimationPlayer = AnimationPlayer.new()
	add_child(animation_player)
	animation_player.add_animation("default", animation)
	animation_player.play("default")

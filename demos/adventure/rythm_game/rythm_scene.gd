extends Control
export(Array, Texture) var icons = []
onready var tracks = $MarginContainer/Tracks.get_children()
onready var ends = $MarginContainer/End.get_children()
onready var container = $MarginContainer
var tracksNotes = [
	[],
	[],
	[],
	[]
]
export(PackedScene) var note_scene
var speed = 1000.0
var score = 0
var is_playing = false

signal ended(score)

var inputs = [
	"a",
	"x",
	"b",
	"y"
]
var notes : Array = [
	[0.1, [1,0,0,0]],
	[2.0, [0,1,0,0]],
	[1.0, [0,0,1,0]],
	[0.9, [0,0,0,1]],
	[0.8, [0,1,0,0]],
	[0.8, [0,1,0,0]],
	[0.8, [0,0,1,0]],
	[0.7, [0,1,0,0]],
	[0.6, [1,0,0,0]],
	[0.5, [0,0,0,1]],
	[0.8, [0,1,0,0]],
	[0.8, [0,1,0,0]],
	[0.4, [1,0,0,0]],
	[0.3, [0,1,0,0]],
	[0.8, [0,0,1,0]],
	[0.8, [0,1,0,0]],
	[0.3, [0,0,1,0]],
	[0.6, [0,0,0,1]],
	[0.2, [0,1,0,0]],
	[0.8, [1,0,0,0]],
	[0.4, [0,0,0,1]],
	[0.6, [0,1,0,0]],
	[0.2, [1,0,0,0]],
]
var max_score = notes.size()

func _unhandled_input(_event):
	if !is_playing: return
	for note_input_index in (inputs.size()):
		var note_input = inputs[note_input_index]
		if Input.is_action_just_pressed("0_" + note_input + "_button"):
			for note in tracksNotes[note_input_index]:
				var note_y = note.rect_global_position.y
				var half_note = note.rect_size.y / 2
				var end_y = ends[note_input_index].rect_global_position.y 
				var half_end = ends[note_input_index].rect_size.y / 2
				var h = half_note + half_end
				var diff = abs(note_y-end_y)
				if diff < h:
					# Hit a note!
					note.touche()
					tracksNotes[note_input_index].erase(note)
					ends[note_input_index].hit()
					var note_score = ceil((diff / h) * 3)
					increment_score(note_score)
					check_notes()
					return
			ends[note_input_index].miss()
			increment_score(-1)
			
func _ready():
	$AnimationPlayer.play("count")
	yield($AnimationPlayer, "animation_finished")
	is_playing = true
	loop()
	
func _process(_delta):
	for note_index in range(tracksNotes.size()):
		for note in tracksNotes[note_index]:
			var s = container.rect_position + tracks[note_index].rect_global_position
			var e = container.rect_position + ends[note_index].rect_global_position
			s.y -= ends[note_index].rect_size.y
			e.y += ends[note_index].rect_size.y
			var is_out = note.interpolate(s, e, speed)
			if is_out:
				# note left without being hit...
				tracksNotes[note_index].erase(note)
				check_notes()
				note.out()
				increment_score(-1)
				
func check_notes():
	var has_notes_on_track = false
	for n in tracksNotes:
		if n.size() > 0:
			has_notes_on_track = true
			break
	if notes.size() == 0 && !has_notes_on_track:
		# End ! 
		is_playing = false
		emit_signal("ended", score)
		
func loop():
	var note = notes.pop_front()
	$Timer.wait_time = note[0]
	$Timer.start()
	yield($Timer, "timeout")
	# add notes
	for note_index in range(note[1].size()):
		if note[1][note_index] == 0: continue
		var t = note_scene.instance()
		tracksNotes[note_index].append(t)
		add_child(t)
		t.time_start = OS.get_ticks_msec()
		t.texture = icons[note_index]
		t.rect_size = ends[note_index].rect_size
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		t.setup()
	if notes.size() == 0:
		return
	else:
		loop()

func increment_score(value):
	var new_score = score + value
	score = clamp(new_score, 0, max_score)
	

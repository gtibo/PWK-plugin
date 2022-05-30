extends AudioStreamPlayer3D

export(Array, AudioStreamSample) var steps_sound

var active = false

func desactivate():
	if !active : return	
	active = false
	stop()
	
func activate():
	if active : return
	active = true
	play_step()

func play_step():
	var step_id = floor(rand_range(0, steps_sound.size()))
	stream = steps_sound[step_id]
	play()

func _on_AudioStreamPlayer3D_finished():
	play_step()

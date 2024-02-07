extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]
@export var min_pitch = .9
@export var max_pitch = 1.1
@export var randomize_pitch = true

func play_random():
	if streams == null || streams.size() == 0:
		return
	
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1
		
	var chosen_stream = streams.pick_random()
	stream = chosen_stream
	play()

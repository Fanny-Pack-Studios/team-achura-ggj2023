@tool
extends Node

var current

func play_random():
	var stream: AudioStreamPlayer3D = get_children().pick_random()
	stream.pitch_scale = randf_range(0.8, 1.2)
	stream.play()
	current = stream

func stop():
	if current:
		current.stop()

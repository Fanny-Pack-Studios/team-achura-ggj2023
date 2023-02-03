extends Node

@export var fade_time = 1

@onready var current: AudioStreamPlayer = $Sid

var fade_out_tween: Tween
var fade_in_tween: Tween

func _ready():
	current.play()
	current.volume_db = 0
	
func change_music(to: String):
	print("Changing music to ", to)
	var stream = get_node(to)
	
	if stream is AudioStreamPlayer and stream != current:
		stream.play(current.get_playback_position())
		fade_in(stream)
		fade_out(current)
		current = stream
		
func fade_out(track: AudioStreamPlayer):
	print("Fading out ", track)
	fade_with("fade_out_tween", track, -20.0)
	await fade_out_tween.finished
	print("Fade out finished")
	track.stop()
	
func fade_in(track: AudioStreamPlayer):
	fade_with("fade_in_tween", track, 0)
	
func fade_with(fader_property: String, track: AudioStreamPlayer, to: float):
	var fader = get(fader_property)
	
	if fader:
		fader.kill()
		
	fader = get_tree().create_tween()
	print("Calling tween with ", track, to)

	fader.tween_property(track, "volume_db", to, fade_time).from_current()
	
	set(fader_property, fader)

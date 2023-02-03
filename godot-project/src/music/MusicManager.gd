extends Node

@export var fade_time = 1

@onready var current: AudioStreamPlayer = $Sid

var fade_out_tween: Tween
var fade_in_tween: Tween

func _ready():
	current.play()
	current.volume_db = 0
	
func change_music(to: String):
	var stream = get_node(to)
	
	if stream is AudioStreamPlayer and stream != current:
		stream.play(current.get_playback_position())
		fade_in(stream)
		fade_out(current)
		current = stream
		
func fade_out(track: AudioStreamPlayer):
	fade_with("fade_out_tween", track, -40.0, Tween.EASE_IN)
	await fade_out_tween.finished
	track.stop()
	
func fade_in(track: AudioStreamPlayer):
	fade_with("fade_in_tween", track, 0, Tween.EASE_OUT)
	
func fade_with(fader_property: String, track: AudioStreamPlayer, to: float, easing):
	var fader = get(fader_property)
	
	if fader:
		fader.kill()
		
	fader = get_tree().create_tween()

	fader.tween_property(track, "volume_db", to, fade_time).set_trans(Tween.TRANS_EXPO).set_ease(easing)
	
	set(fader_property, fader)

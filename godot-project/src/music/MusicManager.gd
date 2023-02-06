extends Node

@export var fade_time = 1

@onready var current: AudioStreamPlayer = $Sid

var fade_out_tween: Tween
var fade_in_tween: Tween

var fade_in_volume:= 0
var fade_out_volume:= -40.0

var reduce_music_effect: AudioEffectAmplify = AudioEffectAmplify.new()

func _ready():
	current.play()
	current.volume_db = fade_in_volume
	AudioServer.add_bus_effect(1, reduce_music_effect)
	
func change_music(to: String):
	var stream = get_node(to)
	
	if stream is AudioStreamPlayer and stream != current:
		stream.play(current.get_playback_position())
		fade_in(stream)
		fade_out(current)
		current = stream
		
func fade_out(track: AudioStreamPlayer):
	fade_with("fade_out_tween", track, fade_out_volume, Tween.EASE_IN)
	await fade_out_tween.finished
	track.stop()
	
func fade_in(track: AudioStreamPlayer):
	fade_with("fade_in_tween", track, fade_in_volume, Tween.EASE_OUT)
	
func fade_with(fader_property: String, object_to_fade, to: float, easing):
	var fader = get(fader_property)
	
	if fader:
		fader.kill()
		
	fader = create_tween()

	fader.tween_property(object_to_fade, "volume_db", to, fade_time).set_trans(Tween.TRANS_EXPO).set_ease(easing)
	
	set(fader_property, fader)
	
var stingers_playing = []
var reduce_music_fader: Tween

func play_stinger(stinger: String):
	var stream = get_node(stinger)
	if stream is AudioStreamPlayer:
		stream.play()
		if !stingers_playing.has(stream):
			stingers_playing.push_back(stream)
		
		if is_zero_approx(reduce_music_effect.volume_db):
			fade_with("reduce_music_fader", reduce_music_effect, -30, Tween.EASE_IN)

		await stream.finished
		
		stingers_playing.erase(stream)
		if stingers_playing.size() == 0:
			fade_with("reduce_music_fader", reduce_music_effect, 0, Tween.EASE_OUT)
		

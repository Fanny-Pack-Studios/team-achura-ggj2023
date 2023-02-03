extends Node

func _on_sid_planted():
	MusicManager.change_music("Turret")

func _on_sid_unplanted():
	MusicManager.change_music("Sid")

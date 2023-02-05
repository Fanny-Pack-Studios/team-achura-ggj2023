extends Control

func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_button_credits_pressed():
	get_tree().change_scene_to_file("res://src/ui/Credits.tscn")

extends Node3D

func _on_button_pressed():
	get_tree().change_scene_to_file("res://src/ui/Title.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")

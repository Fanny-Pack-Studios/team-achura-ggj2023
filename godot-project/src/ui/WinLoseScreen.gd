extends Control

var victory = false

func _process(delta):
	if get_tree().get_nodes_in_group("Enemies").size() <= 0 and !victory:
		victory = true
		show_win_label()

func show_win_label():
	MusicManager.play_stinger("Win")
	$CanvasLayer/CenterContainer/VBoxContainer/Label.text = "Level Completed!"
	$CanvasLayer/CenterContainer/VBoxContainer.show()
	
func show_lose_label():
	MusicManager.play_stinger("Defeat")
	$CanvasLayer/CenterContainer/VBoxContainer/Label.text = "Game Over!"
	$CanvasLayer/CenterContainer/VBoxContainer.show()

func restart():
	get_tree().change_scene_to_file("res://Main.tscn")
	
func to_menu():
	get_tree().change_scene_to_file("res://src/ui/Title.tscn")

extends Control

func _process(delta):
	global_position = get_viewport().get_camera_3d().unproject_position(get_parent().global_position)

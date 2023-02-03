extends Node

var player_bullet_layer: int = 3

func get_player():
	if get_tree().get_nodes_in_group("Player").size() > 0:
		return get_tree().get_nodes_in_group("Player")[0]

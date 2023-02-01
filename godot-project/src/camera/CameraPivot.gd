extends Node3D

@export var character_to_follow_path: NodePath

@onready var character_to_follow: Node3D = get_node(character_to_follow_path)

func _process(delta):		
	if is_instance_valid(character_to_follow):
		position = character_to_follow.position

extends Node

@export var damage = 10

func get_damage():
	return damage

func _on_area_entered(area):
	area.get_damaged(damage)
	get_parent().queue_free()

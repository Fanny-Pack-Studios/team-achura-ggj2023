extends Node

@export var damage = 10

signal impact(area)
signal impacted(damage)

func get_damage():
	return damage

func _on_area_entered(area):
	area.get_damaged(damage)
	emit_signal("impact", area)
	
func get_damaged(damage):
	emit_signal("impacted", damage)

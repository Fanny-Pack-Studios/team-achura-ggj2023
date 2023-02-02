extends Area3D

@export var damage = 10

func get_damage():
	return damage

func set_damage(d):
	damage = d

func trigger():
	for area in get_overlapping_areas():
		area.get_damaged(damage)

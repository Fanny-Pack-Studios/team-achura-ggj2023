class_name Hitbox
extends Area3D

@export var damage := 10.0

var effects: get = get_effects

func get_effects():
	return get_children().filter(func(child:Node): return child is AttackEffect)

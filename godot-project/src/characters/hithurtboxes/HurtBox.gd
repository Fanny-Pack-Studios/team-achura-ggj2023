extends Node

signal damaged(amount, hitbox)

func get_damaged(amount, hitbox):
	emit_signal("damaged", amount, hitbox)

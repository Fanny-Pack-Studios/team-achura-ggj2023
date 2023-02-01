extends Node

signal damaged

func get_damaged(amount):
	emit_signal("damaged", amount)

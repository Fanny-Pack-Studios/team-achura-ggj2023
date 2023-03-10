class_name HealthBehaviour
extends Node

signal damaged(amount)
signal no_health
signal healed(amount)
signal current_changed(amount)
signal max_changed(amount)

@export var max_health:= 100

var current_health

func _ready():
	set_max_health(max_health)
	set_current_health(max_health)
	
func set_current_health(h):
	current_health = h
	emit_signal("current_changed" , current_health)
	
func set_max_health(h):
	max_health = h
	emit_signal("max_changed" , max_health)
	
func get_max_health():
	return max_health

func get_damaged(amount):
	current_health -= amount
	emit_signal("damaged", amount)
	if current_health <= 0:
		emit_signal("no_health")
		
func get_healed(amount):
	current_health = clamp(current_health + amount, 0, max_health)
	emit_signal("healed", amount)

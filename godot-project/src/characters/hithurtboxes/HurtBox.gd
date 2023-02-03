class_name HurtBox
extends Area3D

@export_node_path("HealthBehaviour") var healthBehaviourPath: NodePath = "../HealthBehaviour"

@onready var healthBehaviour: HealthBehaviour = get_node_or_null(healthBehaviourPath)

signal damaged(amount, hitbox)

func get_damaged(amount, hitbox):
	if healthBehaviour:
		healthBehaviour.get_damaged(amount)
		
	emit_signal("damaged", amount, hitbox)
	
func aggro():
	pass

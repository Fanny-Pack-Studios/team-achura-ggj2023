extends Node3D

func _ready():
	$Particles.emitting = true
	
	await get_tree().create_timer($Particles.lifetime).timeout
	
	queue_free()

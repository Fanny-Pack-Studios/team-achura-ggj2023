extends Node3D

func _on_health_behaviour_damaged(damage):
	$EffectsAnimationPlayer.stop()
	$EffectsAnimationPlayer.play("Hurt")


func die():
	queue_free()

func _on_health_behaviour_no_health():
	die()

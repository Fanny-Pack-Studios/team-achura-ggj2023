extends Node3D

func _on_pickup_area_body_entered(body: Sid):
	if body is Sid:
		body.add_lightning_power()

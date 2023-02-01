class_name Turret
extends Node3D

var active: bool = false

func _physics_process(delta):
	if active:
		turret_process(delta)

func turret_process(_delta):
	# For subclasses to override
	pass

func activation():
	# For subclasses to override.
	pass

func deactivation():
	# For subclasses to override.
	pass

func activate():
	visible = true
	await activation()
	active = true

func deactivate():
	active = false
	await deactivation()
	visible = false
	

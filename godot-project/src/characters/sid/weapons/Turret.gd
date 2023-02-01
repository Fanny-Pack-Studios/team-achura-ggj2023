class_name Turret
extends Node3D

@export var look_at_target_mode := LookAtTargetMode.ALWAYS
var active: bool = false
var target_direction: Vector3 = Vector3.ZERO

var deactivating = false
var activating = false

enum LookAtTargetMode {
	ALWAYS,
	ONLY_WHEN_ACTIVE,
	OFF
}

func _physics_process(delta):
	if active:
		turret_process(delta)
	
	if look_at_target_mode == LookAtTargetMode.ALWAYS || (look_at_target_mode == LookAtTargetMode.ONLY_WHEN_ACTIVE && active):
		process_input()
		look_at_target()

func look_at_target():
	look_at(global_position + target_direction)

func process_input():
	var mouse_position = InputUtils.get_mouse_position_on_same_plane(self)
	
	target_direction = (mouse_position - global_position).normalized()

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
	if activating:
		return
	activating = true
	visible = true
	active = await activation()
	activating = false

func deactivate():
	if deactivating:
		return
	deactivating = true
	active = false
	await deactivation()
	visible = false
	deactivating = false
	

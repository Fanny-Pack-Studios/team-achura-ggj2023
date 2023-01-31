extends Character

@export var move_speed := 3.0

@export var target: Node3D

func _target_position() -> Vector3:
	return target.position

func _physics_process(delta):
	super._physics_process(delta)
	if is_instance_valid(target):
		$AccelerationBehaviour.towards_target(_target_position())


func look_at_quat(quat):
	var scale = global_transform.basis.get_scale()
	global_transform.basis = Basis(quat).scaled(scale)


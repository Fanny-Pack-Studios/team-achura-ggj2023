class_name MathUtils
extends Object

static func xz_vector(vec: Vector3) -> Vector3:
	return Vector3(vec.x, 0, vec.z)


static func look_at_quat(transform: Transform3D, quat: Quaternion):
	var scale = transform.basis.get_scale()
	transform.basis = Basis(quat).scaled(scale)
	return transform

static func target_quat_direction(input_direction: Vector3):
	return Quaternion(
		Basis(input_direction.rotated(Vector3.UP, -PI / 2), Vector3.UP, -input_direction).orthonormalized()
	)

static func instantly_look_at_direction(transform: Transform3D, input_direction: Vector3):
	var target_quat = target_quat_direction(input_direction)
	return look_at_quat(transform, target_quat)


static func rotate_to_look_at_direction(transform: Transform3D, direction: Vector3, max_delta: float):
	if Vector3.ZERO == direction:
		return
		
	var target_quat = target_quat_direction(direction)
	var current_quat = Quaternion(transform.basis.orthonormalized())

	var angleDiff = target_quat.angle_to(current_quat)

	if max_delta >= angleDiff:
		current_quat = target_quat
	else:
		var weight = max_delta / angleDiff

		current_quat = current_quat.slerp(target_quat, weight)

	return look_at_quat(transform, current_quat)

static func forward(transform: Transform3D):
	return -transform.basis.z

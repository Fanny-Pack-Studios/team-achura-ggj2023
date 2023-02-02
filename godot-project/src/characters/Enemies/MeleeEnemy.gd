extends Character

@export var move_speed := 3.0

@export var target: Node3D

@export var aggro_range: float = 5

@export var size: float = 1

var attack_range: float = 1.1

func _ready():
	scale = Vector3(size, size, size)
	attack_range = attack_range * size
	move_speed = move_speed / size
	$HealthBehaviour.set_max_health($HealthBehaviour.get_max_health() * size)
	$HealthBehaviour.set_current_health($HealthBehaviour.get_max_health())
	$AttackArea.set_damage($AttackArea.get_damage() * (size/2))

func _target_position() -> Vector3:
	return target.position

func _physics_process(delta):
	super._physics_process(delta)
	if is_instance_valid(target):
		if not $AttackingBehaviour.is_attacking():
			if _target_position().distance_to(position) < attack_range:
				$AttackingBehaviour.start_attacking()
			elif _target_position().distance_to(position) < aggro_range:
				$AccelerationBehaviour.towards_target(_target_position(), move_speed)
			else:
				$AccelerationBehaviour.clear_target()
		else:
			$AccelerationBehaviour.towards_target(_target_position(), 0)
	else:
		$AccelerationBehaviour.clear_target()

func look_at_quat(quat):
	var scale = global_transform.basis.get_scale()
	global_transform.basis = Basis(quat).scaled(scale)
		
func get_damaged(amount):
	$HealthBehaviour.get_damaged(amount)
		
func die():
	queue_free()

func _on_attacking_behaviour_attack():
	$AttackArea.trigger()

func _on_hurt_area_damaged(amount):
	get_damaged(amount)

func _on_health_behaviour_no_health():
	die()

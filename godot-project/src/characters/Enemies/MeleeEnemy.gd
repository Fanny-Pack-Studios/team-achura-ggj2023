extends Character

@export var move_speed := 3.0

@export var aggro_range: float = 5
@export var aggroed_range: float = 20

@export var size: float = 1

var target: Node3D

var attack_range: float = 1.1

func _ready():
	scale = Vector3(size, size, size)
	attack_range = attack_range * size
	move_speed = move_speed / size
	$HealthBehaviour.set_max_health($HealthBehaviour.get_max_health() * size)
	$HealthBehaviour.set_current_health($HealthBehaviour.get_max_health())
	$AttackArea.damage = $AttackArea.damage * (size/2)
	target = get_tree().get_nodes_in_group("Player")[0]

func _target_position() -> Vector3:
	return target.position

func _physics_process(delta):
	super._physics_process(delta)
	if is_instance_valid(target):
		$AccelerationBehaviour.turn_speed = PI
		if not $AttackingBehaviour.is_attacking():
			if _target_position().distance_to(position) < attack_range:
				$AttackingBehaviour.start_attacking()
			elif _target_position().distance_to(position) < aggro_range:
				$AccelerationBehaviour.towards_target(_target_position(), move_speed)
			else:
				var new_direction = global_position.direction_to($IdleTarget.global_position)
				$AccelerationBehaviour.turn_speed = PI/5
				$AccelerationBehaviour.towards_direction(new_direction, move_speed / 2)
		else:
			$AccelerationBehaviour.towards_target(_target_position(), 0)
	else:
		$AccelerationBehaviour.clear_target()

func look_at_quat(quat):
	var scale = global_transform.basis.get_scale()
	global_transform.basis = Basis(quat).scaled(scale)
		
func get_damaged(amount):
	$EffectsAnimationPlayer.stop()
	$EffectsAnimationPlayer.play("Hurt")
	aggro()
	alert_allies()

func alert_allies():
	for enemy in $AlertRange.get_overlapping_bodies():
		enemy.aggro()

func aggro():
	aggro_range = aggroed_range
		
func die():
	queue_free()

func _on_attacking_behaviour_attack():
	$AttackArea.trigger()

func _on_hurt_area_damaged(amount, hitbox: Hitbox):
	get_damaged(amount)
	for effect in hitbox.effects:
		effect.apply_on_character(self)

func _on_health_behaviour_no_health():
	die()

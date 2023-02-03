extends Character

@export var move_speed := 2.0

@export var health: int = 5

@export var attack_range: float = 3
@export var aggro_range: float = 7
@export var aggroed_range: float = 20

@export var bullet_scene: PackedScene

var target: Node3D

func _ready():
	if get_tree().get_nodes_in_group("Player").size() > 0:
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
	$ShootingProjectileBehaviour.shoot()

func _on_hurt_area_damaged(amount, hitbox: Hitbox):
	get_damaged(amount)
	for effect in hitbox.effects:
		effect.apply_on_character(self)

func _on_health_behaviour_no_health():
	die()

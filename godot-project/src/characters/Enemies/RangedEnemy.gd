extends Character

@export var move_speed := 2.0

@export var health: int = 5

@export var attack_range: float = 5
@export var aggro_range: float = 7
@export var aggroed_range: float = 20

@export var bullet_scene: PackedScene

var target: Node3D

var dying: bool = false

var shoot_trigger_delay = 1

func _ready():
	target = Global.get_player()

func _target_position() -> Vector3:
	return target.position

func _physics_process(delta):
	if dying:
		return
		
	super._physics_process(delta)
	if is_instance_valid(target):
		$AccelerationBehaviour.turn_speed = PI
		if not $AttackingBehaviour.is_attacking():
			if _target_position().distance_to(position) < attack_range:
				$AttackingBehaviour.start_attacking()
			elif _target_position().distance_to(position) < aggro_range:
				$AccelerationBehaviour.towards_target(_target_position(), move_speed)
				$StateMachine.change_state("Move")
			else:
				var new_direction = global_position.direction_to($IdleTarget.global_position)
				$AccelerationBehaviour.turn_speed = PI/5
				$AccelerationBehaviour.towards_direction(new_direction, move_speed / 2)
				$StateMachine.change_state("Move")
		else:
			$AccelerationBehaviour.towards_target(_target_position(), 0)
			$StateMachine.change_state("Idle")
	else:
		$AccelerationBehaviour.clear_target()
		$StateMachine.change_state("Idle")

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
	dying = true
	for node in [$EnemyHPBar, $AccelerationBehaviour, $AttackingBehaviour, $HealthBehaviour, $HurtArea, $AlertRange, $ShootingProjectileBehaviour]:
		node.queue_free()
	$StateMachine.change_state("Die")
	$EffectsAnimationPlayer.queue("Die")

	while await $EffectsAnimationPlayer.animation_finished != "Die":
		pass
		
	queue_free()

func _on_attacking_behaviour_attack():
	$StateMachine.change_state("Shoot")
	await get_tree().create_timer(shoot_trigger_delay).timeout
	if $StateMachine.current_state() == "Shoot":
		$ShootingProjectileBehaviour.shoot()
	

func _on_hurt_area_damaged(amount, hitbox: Hitbox):
	get_damaged(amount)
	for effect in hitbox.effects:
		effect.apply_on_character(self)

func _on_health_behaviour_no_health():
	die()

extends Character

@export var move_speed := 3.0

@export var aggro_range: float = 5
@export var aggroed_range: float = 20

@export var size: float = 1

var target: Node3D

var attack_range: float = 2.0

#TODO: Ver cómo meter esto en la animación?
var attack_trigger_delay := 0.53

var reference_move_speed = 8

func _ready():
	scale = Vector3(size, size, size)
	attack_range = attack_range * size
	move_speed = move_speed / size
	$HealthBehaviour.set_max_health($HealthBehaviour.get_max_health() * size)
	$HealthBehaviour.set_current_health($HealthBehaviour.get_max_health())
	$AttackArea.damage = $AttackArea.damage * (size/2)
	mass = size
	
	target = Global.get_player()

func _target_position() -> Vector3:
	return target.position

func _physics_process(delta):
	super._physics_process(delta)
	var current_speed = move_speed
	if is_instance_valid(target):
		$AccelerationBehaviour.turn_speed = PI
		if not $AttackingBehaviour.is_attacking():
			if _target_position().distance_to(position) < attack_range:
				$AttackingBehaviour.start_attacking()
			elif _target_position().distance_to(position) < aggro_range:
				$AccelerationBehaviour.towards_target(_target_position(), move_speed)
				$StateMachine.change_state("Walk")
			else:
				var new_direction = global_position.direction_to($IdleTarget.global_position)
				$AccelerationBehaviour.turn_speed = PI/5
				current_speed = move_speed / 2
				$AccelerationBehaviour.towards_direction(new_direction, move_speed / 2)
				$StateMachine.change_state("Walk")
		else:
			$AccelerationBehaviour.towards_target(_target_position(), 0)
			$StateMachine.change_state("Idle")
	else:
		$AccelerationBehaviour.clear_target()
		$StateMachine.change_state("Idle")

	$AnimationTree.set("parameters/Walk/WalkSpeed/scale", current_speed / reference_move_speed)

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
	for node in [$AccelerationBehaviour, $AttackingBehaviour, $HealthBehaviour, $HurtArea, $AttackArea, $AlertRange]:
		queue_free()
	$StateMachine.change_state("die")
	$EffectsAnimationPlayer.play("die")
	while await $EffectsAnimationPlayer.animation_finished != "die":
		pass
	queue_free()

func _on_attacking_behaviour_attack():
	$StateMachine.change_state("Attack")
	await get_tree().create_timer(attack_trigger_delay).timeout
	if $StateMachine.current_state() == "Attack":
		$AttackArea.trigger()

func _on_hurt_area_damaged(amount, hitbox: Hitbox):
	get_damaged(amount)
	for effect in hitbox.effects:
		effect.apply_on_character(self)

func _on_health_behaviour_no_health():
	die()

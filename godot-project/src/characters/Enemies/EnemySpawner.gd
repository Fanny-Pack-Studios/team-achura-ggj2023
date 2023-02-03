extends Node3D

@export var enemies_to_spawn : Array[PackedScene] = [preload("res://src/characters/Enemies/MeleeEnemy.tscn"), preload("res://src/characters/Enemies/RangedEnemy.tscn")]

@export var max_enemies: int = 6

var current_enemies: Array[Node3D] = []

func _on_health_behaviour_damaged(damage):
	$EffectsAnimationPlayer.stop()
	$EffectsAnimationPlayer.play("Hurt")

func die():
	queue_free()

func _on_health_behaviour_no_health():
	die()

func update_current_enemies():
	#TODO: Quizás reemplazar esto por señales de die
	current_enemies = current_enemies.filter(func(enemy): return is_instance_valid(enemy) and enemy.is_inside_tree())

const SPAWN_RADIUS = 1.0

func aggro():
	pass

func spawn_position():
	var angle = randf_range(0, TAU)
	return Vector3(cos(angle), 0, sin(angle)) * SPAWN_RADIUS

func spawn_enemy():
	var enemy_to_spawn_idx = randi_range(0, enemies_to_spawn.size() - 1)
	var enemy = enemies_to_spawn[enemy_to_spawn_idx].instantiate()
	enemy.transform = self.transform
	enemy.translate(spawn_position())
	get_parent().add_child(enemy)

func _on_spawn_timer_timeout():
	update_current_enemies()
	if current_enemies.size() < max_enemies:
		spawn_enemy()

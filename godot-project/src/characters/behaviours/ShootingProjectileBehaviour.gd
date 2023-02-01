class_name ShootingProjectileBehaviour
extends Node

@export var ProjectileScene: PackedScene
@export var spawn_point: Node3D
@export var cooldown_time: float = 0.1

var cooldown_timer: Timer

signal just_shot

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true

func shoot():
	if cooldown_timer.is_stopped():
		var projectile = ProjectileScene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_position = spawn_point.global_position
		projectile.direction = MathUtils.forward(get_parent().global_transform)
		cooldown_timer.start(cooldown_time)
		emit_signal("just_shot")

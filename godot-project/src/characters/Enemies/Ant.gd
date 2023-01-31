extends Character

@export var move_speed := 3.0

@export var target: Node3D

@export var health: int = 5

func _target_position() -> Vector3:
	return target.position

func _physics_process(delta):
	super._physics_process(delta)
	if is_instance_valid(target):
		$AccelerationBehaviour.towards_target(_target_position(), move_speed)
	else:
		$AccelerationBehaviour.clear_target()

func look_at_quat(quat):
	var scale = global_transform.basis.get_scale()
	global_transform.basis = Basis(quat).scaled(scale)

func _on_hurt_area_body_entered(body):
	if body.get_collision_layer() == Global.player_bullet_layer:
		get_damaged(body.get_power())
		
func get_damaged(power):
	health -= power
	if health <= 0:
		die()
		
func die():
	queue_free()
	

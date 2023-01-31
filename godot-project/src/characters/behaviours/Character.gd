class_name Character
extends CharacterBody3D

@export var max_speed := 20.0
@export var affected_by_gravity := true

var gravity_vector : Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var gravity_magnitude : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var moving := true
func _physics_process(delta):
	if affected_by_gravity:
		velocity += gravity_vector * gravity_magnitude * delta
		
	velocity = velocity.limit_length(max_speed)
	
	if moving:
		move_and_slide()

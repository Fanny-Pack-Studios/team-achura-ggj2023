class_name AccelerationBehaviour
extends Node

var target_direction: Vector3 = Vector3()
var target_velocity: Vector3 = Vector3()

@export var move_speed = 2
@export var acceleration_magnitude := 20.0
@export var friction := 50.0
@export var turn_speed := PI
@export var can_fly := false

@export var accelerate_forward := false

const PARENT_WRONG_TYPE_ERROR = "This behaviour requires a CharacterBody3D parent"

var active := true

var velocity: Vector3: set = set_velocity, get = get_velocity

func set_velocity(vel: Vector3):
	character().velocity = vel
	
func get_velocity() -> Vector3:
	return character().velocity

func _get_configuration_warnings():
	if !get_parent() is CharacterBody3D:
		return PARENT_WRONG_TYPE_ERROR

func _ready():
	assert(get_parent() is CharacterBody3D, PARENT_WRONG_TYPE_ERROR)
	
func character() -> CharacterBody3D:
	return get_parent()

func towards_target(target: Vector3):
	var to_target = target - character().position
	target_velocity = to_target.limit_length(move_speed)
	target_direction = to_target.normalized()

func _physics_process(delta):
	var acceleration_to_use = friction if target_velocity.is_zero_approx() else acceleration_magnitude
	
	var target_velocity_to_use = target_velocity
	
	if accelerate_forward:
		target_velocity_to_use = MathUtils.forward(character().global_transform) * move_speed
	
	if can_fly:
		target_velocity_to_use =  MathUtils.xz_vector(target_velocity_to_use)

	velocity = velocity.move_toward(target_velocity_to_use, acceleration_to_use * delta)
	
	if !target_direction.is_zero_approx():
		character().global_transform = MathUtils.rotate_to_look_at_direction(character().global_transform, target_direction, delta * turn_speed)
	

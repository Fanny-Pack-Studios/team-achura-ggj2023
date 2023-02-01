class_name ShootingBehaviour
extends Node

signal shoot

@export var shoot_wait_time :float = 2
@export var turn_speed := PI

var shooting :bool = false
var time :float = 0

const PARENT_WRONG_TYPE_ERROR = "This behaviour requires a CharacterBody3D parent"

func _get_configuration_warnings():
	if !get_parent() is CharacterBody3D:
		return PARENT_WRONG_TYPE_ERROR

func _ready():
	time = shoot_wait_time
	assert(get_parent() is CharacterBody3D, PARENT_WRONG_TYPE_ERROR)
	
func character() -> CharacterBody3D:
	return get_parent()
	
func start_shooting():
	if not shooting:
		time = shoot_wait_time
		shooting = true
	
func is_shooting():
	return shooting

func _physics_process(delta):
	if shooting:
		time -= delta
		if time <= 0:
			shooting = false
			emit_signal("shoot")

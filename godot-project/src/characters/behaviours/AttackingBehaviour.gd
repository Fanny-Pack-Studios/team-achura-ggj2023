class_name AttackingBehaviour
extends Node

signal attack

@export var attack_wait_time :float = 2

var attacking :bool = false
var time :float = 0

const PARENT_WRONG_TYPE_ERROR = "This behaviour requires a CharacterBody3D parent"

func _get_configuration_warnings():
	if !get_parent() is CharacterBody3D:
		return PARENT_WRONG_TYPE_ERROR

func _ready():
	time = attack_wait_time
	assert(get_parent() is CharacterBody3D, PARENT_WRONG_TYPE_ERROR)
	
func character() -> CharacterBody3D:
	return get_parent()
	
func start_attacking():
	if not attacking:
		time = attack_wait_time
		attacking = true
	
func is_attacking():
	return attacking

func _physics_process(delta):
	if attacking:
		time -= delta
		if time <= 0:
			attacking = false
			emit_signal("attack")

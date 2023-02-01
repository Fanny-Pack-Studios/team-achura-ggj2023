extends Node3D

var direction: Vector3 = Vector3.FORWARD

@export var speed = 2

func _ready():
	look_at(global_position + direction)
	
func _physics_process(delta):
	global_translate(direction * speed * delta)

extends Node3D

var direction: Vector3 = Vector3.FORWARD

@export var speed = 10

func _ready():
	transform = transform.looking_at(direction)
	
func _physics_process(delta):
	translate(direction * speed * delta)

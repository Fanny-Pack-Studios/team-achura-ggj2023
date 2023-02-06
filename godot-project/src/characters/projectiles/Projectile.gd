class_name DefaultProjectile

extends Node3D

var direction: Vector3 = Vector3.FORWARD

@export var speed = 10
@export var ExplosionScene: PackedScene
@export var life_time = 1.0

func _ready():
	look_at(global_position + direction)
	
	await get_tree().create_timer(life_time).timeout
	
	if is_inside_tree():
		explode()
	
func _physics_process(delta):
	global_translate(direction * speed * delta)

func add_explosion():
	if ExplosionScene:
		var explosion = ExplosionScene.instantiate()
		explosion.transform = self.transform
		get_parent().add_child(explosion)

func explode():
	add_explosion()
	queue_free()
	
func impact_terrain(terrain_body):
	#Distintos tipos de disparos podrían reaccionar distinto
	explode()
	
func impact_damageable(damageable_area):
	#Distintos tipos de disparos podrían reaccionar distinto
	explode()

func impacted(damage):
	#Distintos tipos de disparos podrían reaccionar distinto
	explode()

extends Node3D

var elapsed: float = 0.0
@export var radius = 1.0
@export var frequency = 0.5
#quise exportar esto y por alguna razón se seteaba solo en basic
var turretType = Turrets.TurretType.LightningTurret

func _physics_process(delta):
	elapsed += delta
	
	var t = frequency * TAU * elapsed
	
	$BodyBase.position.x = cos(t) * radius
	$BodyBase.position.z = sin(t) * radius
	

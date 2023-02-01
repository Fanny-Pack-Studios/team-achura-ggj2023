class_name Turrets
extends Node3D

var current_turret: Turret

enum TurretType {
	BasicTurret
}

func activate(type: TurretType):
	current_turret = get_node(TurretType.keys()[type])
	await current_turret.activate()
	
func deactivate():
	if current_turret and current_turret.active:
		await current_turret.deactivate()

extends Hitbox

signal impact(area)
signal impacted(damage, hitbox)

@export var just_emit_signal := false

func _on_area_entered(area):
	if !just_emit_signal:
		do_impact(area)
	
	emit_signal("impact", area)
	
func do_impact(area):
	area.get_damaged(damage, self)
	
func get_damaged(damage, hitbox):
	emit_signal("impacted", damage, hitbox)

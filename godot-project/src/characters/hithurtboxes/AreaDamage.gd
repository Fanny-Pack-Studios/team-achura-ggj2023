extends Hitbox

signal impact(area)
signal impacted(damage, hitbox)

func _on_area_entered(area):
	area.get_damaged(damage, self)
	emit_signal("impact", area)
	
func get_damaged(damage, hitbox):
	emit_signal("impacted", damage, hitbox)

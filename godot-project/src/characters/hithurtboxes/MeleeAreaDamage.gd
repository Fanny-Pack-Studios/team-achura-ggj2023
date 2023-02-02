extends Hitbox

func trigger():
	for area in get_overlapping_areas():
		area.get_damaged(damage, self)

extends DefaultProjectile

@export var bounces: int = 4

var last_impacted

func impacted(damage):
	pass

func impact_damageable(damageable):
	if damageable != last_impacted:
		$Hitbox.do_impact(damageable)
	else:
		return
	
	last_impacted = damageable
	
	if bounces > 0:
		global_position.x = damageable.global_position.x
		global_position.z = damageable.global_position.z
		bounces -= 1
		var possible_targets = $FindCloseTargetArea.get_overlapping_areas().filter(
			func(area):
				return area != damageable and area.get_parent() != damageable.get_parent()
		)
		
		if possible_targets.size() > 0:
			var next_target = possible_targets.pick_random()
			
			direction = (MathUtils.xz_vector(next_target.global_position) - MathUtils.xz_vector(global_position)).normalized()
		else:
			var angle = randf_range(0, TAU)
			direction = Vector3(cos(angle), 0, sin(angle))
	else:
		explode()
	

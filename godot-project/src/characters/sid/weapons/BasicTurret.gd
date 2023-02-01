extends Turret

var target_direction: Vector3 = Vector3.ZERO

func activation():
	process_input()
	
	look_at(self.global_position + target_direction)
	
	$Player_Turret_Basic/AnimationPlayer.play("turretBasic_Grow")
	
func deactivation():
	$Player_Turret_Basic/AnimationPlayer.play("turretBasic_Die")
	
	await $Player_Turret_Basic/AnimationPlayer.animation_finished

func turret_process(_delta):
	process_input()
	if target_direction != Vector3.ZERO:
		look_at(self.global_position + target_direction)
	
func process_input():
	var mouse_position = InputUtils.get_mouse_position_on_same_plane(self)
	
	target_direction = (mouse_position - global_position).normalized()

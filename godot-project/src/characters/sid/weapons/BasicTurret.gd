extends Turret

const GROW_STATE = &"Grow"
const AIM_STATE = &"Aim"
const DIE_STATE = &"Die"
const SHOOT_STATE = &"Shoot"

func _ready():
	$Player_Turret_Basic/AnimationPlayer.get_animation("turretBasic_Aim").loop_mode = Animation.LOOP_LINEAR

func turret_process(delta):
	if Input.is_action_just_pressed("shoot"):
		$ShootingProjectileBehaviour.shoot()

func animation_tree_state_machine():
	return $AnimationTree

func activation():
	look_at(self.global_position + target_direction)
		
	$StateMachine.change_state(GROW_STATE)
	
	await $AnimationTree.animation_finished
	
func deactivation():
	$StateMachine.change_state(DIE_STATE)
	
	await $AnimationTree.animation_finished


func _on_shooting_projectile_behaviour_just_shot():
	$StateMachine.change_state(SHOOT_STATE, func(a):pass, true)

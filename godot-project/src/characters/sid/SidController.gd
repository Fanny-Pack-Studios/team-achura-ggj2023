extends Character

@export var camera: Camera3D

var input_direction_3d: Vector3 = Vector3()

@onready var animation_player = $Player/AnimationPlayer

@export var can_cancel_plant: bool = true
@export var plant_cancel_time := 0.7
@export var time_frozen_when_unplanting := 0.9
@export var move_speed := 5.0
@export var health := 100

var toggle_planting: bool = false

const PLANT_STATE = &"Plant"
const IDLE_STATE = &"Idle"
const RUN_STATE = &"Run"
const UNPLANT_STATE = &"Unplant"
#NO SE USA POR AHORA, PERO PODRÍA VOLVER
const DEACTIVATING_STATE = &"Deactivating"

const states_that_allow_movement = [IDLE_STATE, RUN_STATE]

signal planted
signal unplanted

func is_planting_cancellable():
	return can_cancel_plant and $PlantCancelTimer.time_left > 0

func _physics_process(delta):
	process_input()
	process_state($StateMachine.current_state())
	
	super._physics_process(delta)

func allows_movement(state: StringName):
	return state in states_that_allow_movement || (
		is_planting_cancellable() and state == PLANT_STATE
	) || (
		$UnplantAllowMovementTimer.time_left <= 0 and state == UNPLANT_STATE
	) 
		

func change_state(new_state: StringName):
	$StateMachine.change_state(new_state, self.enter_state)

func process_state(state):
	if input_direction_3d != Vector3.ZERO and allows_movement(state):
		$AccelerationBehaviour.towards_direction(input_direction_3d, move_speed)
	else:
		$AccelerationBehaviour.clear_target()
	
	match state:
		PLANT_STATE:
			if toggle_planting:
				if is_planting_cancellable():
					change_state(IDLE_STATE)
					$Sounds/Plant.stop()
				else:
					$Turrets.deactivate()
					change_state(UNPLANT_STATE)
		IDLE_STATE: 
			if toggle_planting:
				change_state(PLANT_STATE)
			elif input_direction_3d != Vector3.ZERO:
				change_state(RUN_STATE)
		RUN_STATE:
			if toggle_planting:
				change_state(PLANT_STATE)
			elif input_direction_3d == Vector3.ZERO:
				change_state(IDLE_STATE)
		UNPLANT_STATE:
			if $UnplantAllowMovementTimer.time_left <= 0 and input_direction_3d != Vector3.ZERO:
				change_state(RUN_STATE)

func enter_state(new_state: StringName):
	match new_state:
		PLANT_STATE: 
			$PlantCancelTimer.start(plant_cancel_time)
			
			$Sounds/Plant.play()
			
			await $PlantCancelTimer.timeout
			
			if $StateMachine.current_state() == PLANT_STATE:
				emit_signal("planted")
				$Turrets.activate(Turrets.TurretType.BasicTurret)
			
		UNPLANT_STATE:
			$Sounds/Unplant.play()
			
			$UnplantAllowMovementTimer.start(time_frozen_when_unplanting)
			emit_signal("unplanted")
			

func process_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		var camera_forward = get_camera_forward()
		input_direction_3d = Vector3(input_direction.x, 0, input_direction.y).normalized()
		
		input_direction_3d = input_direction_3d.rotated(Vector3.UP, camera_forward.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	else:
		input_direction_3d = Vector3.ZERO
		
	toggle_planting = Input.is_action_just_pressed("toggle_planting")
		

func _ready():
	for anim in ["Idle", "Run"]:
		animation_player.get_animation(anim).loop_mode = Animation.LOOP_LINEAR
		
	DebugOverlay.add_vector(self, "input_direction_3d")

func get_camera_forward() -> Vector3: 
	var zbasis = camera.global_transform.basis.z
	return -Vector3(zbasis.x, 0, zbasis.z).normalized()
	
func get_damaged(amount):
	$HealthBehaviour.get_damaged(amount)
	$EffectsAnimationPlayer.stop()
	$EffectsAnimationPlayer.play("Hurt")

func _on_health_behaviour_no_health():
	queue_free()

func _on_hurt_box_damaged(amount, hitbox):
	get_damaged(amount)

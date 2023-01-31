extends Character

@export var camera: Camera3D

var input_direction_3d: Vector3 = Vector3()

@onready var animation_player = $Player/AnimationPlayer

@export var can_cancel_plant: bool = true
@export var plant_cancel_time := 0.7
@export var move_speed := 5.0

var toggle_planting: bool = false

# Quise usar las constantes pero por alguna razón no andan en el match. Para analizar
const PLANT_STATE := "Plant"
const IDLE_STATE := "Idle"
const RUN_STATE := "Run"

func is_planting_cancellable():
	return can_cancel_plant and $PlantCancelTimer.time_left > 0

func _physics_process(delta):
	process_input()
	
	match current_state():
		"Plant":
			if input_direction_3d != Vector3.ZERO and is_planting_cancellable():
				$AccelerationBehaviour.towards_direction(input_direction_3d, move_speed)
			else:
				$AccelerationBehaviour.clear_target()
			
			if toggle_planting:
				if is_planting_cancellable():
					set_cancel_planting(true)
				else:
					change_state("Idle")
			
		"Idle": 
			if toggle_planting:
				change_state(PLANT_STATE)
			elif input_direction_3d != Vector3.ZERO:
				change_state(RUN_STATE)
				$AccelerationBehaviour.towards_direction(input_direction_3d, move_speed)
		"Run":
			if toggle_planting:
				change_state(PLANT_STATE)
			elif input_direction_3d != Vector3.ZERO:
				$AccelerationBehaviour.towards_direction(input_direction_3d, move_speed)
			else:
				$AccelerationBehaviour.clear_target()
				change_state(IDLE_STATE)
	
	super._physics_process(delta)

func set_cancel_planting(val: bool):
	$AnimationTree.set("parameters/conditions/plant_cancel", val)

func current_state():
	return animation_state_machine().get_current_node()
	
func enter_state(new_state: String):
	match new_state:
		PLANT_STATE: 
			set_cancel_planting(false)
			$PlantCancelTimer.start(plant_cancel_time)

func change_state(new_state: String):
	if current_state() != new_state:
		enter_state(new_state)
		animation_state_machine().travel(new_state)
	
func animation_state_machine() -> AnimationNodeStateMachinePlayback:
	return $AnimationTree["parameters/playback"]

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

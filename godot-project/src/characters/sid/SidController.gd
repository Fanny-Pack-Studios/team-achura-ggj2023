extends Character

@export var camera: Camera3D

var input_direction_3d: Vector3 = Vector3()

@onready var animation_player = $Player/AnimationPlayer

@export var can_cancel_plant: bool = true
@export var move_speed := 5.0

var planting: bool = false

func _physics_process(delta):
	process_input()
	
	var is_cancellable = (can_cancel_plant || animation_state_machine().get_current_play_position() == 1)
	
	if is_cancellable && animation_state_machine().get_current_node() == "Plant" && not Input.is_action_pressed("plant"):
		animation_state_machine().travel("Unplant")
		planting = false
	
	if is_on_floor() && Input.is_action_just_pressed("plant"):
		animation_state_machine().travel("Plant")
		velocity.x = 0
		velocity.z = 0
		planting = true
		
	if animation_state_machine().get_current_play_position() == 1 && planting:
		print("shooot!")
	
	if not planting:
		if input_direction_3d != Vector3.ZERO:
			$AccelerationBehaviour.towards_direction(input_direction_3d, move_speed)
			
			change_state("Run")
		else:
			$AccelerationBehaviour.clear_target()
			
			change_state("Idle")
	
	super._physics_process(delta)

func change_state(new_state):
	if animation_state_machine().get_current_node() != new_state:
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
		

func _ready():
	for anim in ["Idle", "Run"]:
		animation_player.get_animation(anim).loop_mode = Animation.LOOP_LINEAR
		
	DebugOverlay.add_vector(self, "input_direction_3d")

func get_camera_forward() -> Vector3: 
	var zbasis = camera.global_transform.basis.z
	return -Vector3(zbasis.x, 0, zbasis.z).normalized()

extends CharacterBody3D

var gravity_vector : Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var gravity_magnitude : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var running_speed: float = 4
@export var walking_speed: float = 2

var walking: bool = false

@export var camera_path: NodePath

@onready var camera: Camera3D = get_node_or_null(camera_path)

var input_direction_3d: Vector3 = Vector3()

@export var turn_speed: float = 5 * PI

@onready var animation_player = $Player/AnimationPlayer

@export var can_cancel_plant: bool = true
var planting: bool = false

func _physics_process(delta):
	process_input()
	
	velocity += gravity_vector * gravity_magnitude * delta
	
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
			var target_quat = Quaternion(Basis(input_direction_3d.rotated(Vector3.UP, -PI/2), Vector3.UP, -input_direction_3d))
			var current_quat = Quaternion(transform.basis.orthonormalized())
			
			var angleDiff = target_quat.angle_to(current_quat)
		
			var max_delta_rotation = turn_speed * delta
			
			if(max_delta_rotation >= angleDiff):
				current_quat = target_quat
			else:
				var weight = max_delta_rotation / angleDiff
				
				current_quat = current_quat.slerp(target_quat, weight)
				
			var scale = transform.basis.get_scale()
			
			transform.basis = Basis(current_quat).scaled(scale) 

			#transform.basis = Basis(current_front_vector.rotated(Vector3.UP, -PI/2), Vector3.UP, -current_front_vector)
			
			var forward_velocity = get_speed() * -global_transform.basis.z
			velocity.x = forward_velocity.x
			velocity.z = forward_velocity.z
			if animation_state_machine().get_current_node() != "Run":
				animation_state_machine().travel("Run")
		else:
			if animation_state_machine().get_current_node() != "Idle":
				animation_state_machine().travel("Idle")
			velocity.x = 0
			velocity.z = 0
	
	move_and_slide()

func animation_state_machine() -> AnimationNodeStateMachinePlayback:
	return $AnimationTree["parameters/playback"]

func get_speed():
	return walking_speed if walking else running_speed

func process_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		var camera_forward = get_camera_forward()
		input_direction_3d = Vector3(input_direction.x, 0, input_direction.y).normalized()
		
		input_direction_3d = input_direction_3d.rotated(Vector3.UP, camera_forward.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	else:
		input_direction_3d = Vector3.ZERO
		
	walking = Input.is_action_pressed("walking")
		

func _ready():
	for anim in ["Idle", "Run"]:
		animation_player.get_animation(anim).loop_mode = Animation.LOOP_LINEAR
		
	DebugOverlay.add_vector(self, "input_direction_3d")

func get_camera_forward() -> Vector3: 
	var zbasis = camera.global_transform.basis.z
	return -Vector3(zbasis.x, 0, zbasis.z).normalized()

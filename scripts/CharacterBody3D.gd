extends CharacterBody3D


const DEFAULT_SPEED = 7.5
const RUNNING_SPEED = 11.0
const JUMP_VELOCITY = 3.5
const SENSITIVITY = 0.001

var gravity = 10

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	
	var SPEED = DEFAULT_SPEED
	
	if Input.is_action_pressed("RUN"):
		SPEED = RUNNING_SPEED

	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("SPACE") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("A", "D", "W", "S")
	# get_vector recebe no R2 (x,y)
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#print(neck.transform.basis)
	#print(Vector3(input_dir.x, 0, input_dir.y))
	#print(direction)
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2.0)

	move_and_slide()

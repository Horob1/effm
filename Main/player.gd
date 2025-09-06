extends CharacterBody3D

@export var speed := 5.0
@export var mouse_sensitivity := 0.002

var camera: Camera3D

func _ready():
	camera = $SpringArm3D/Camera3D
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)

func _physics_process(delta):
	var dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x

	velocity.x = dir.normalized().x * speed
	velocity.z = dir.normalized().z * speed
	move_and_slide()

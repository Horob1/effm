extends Node3D
@onready var mr_fat_man: CharacterBody3D = $MrFatMan

@onready var player: CharacterBody3D = $Player
@onready var joystick_look: VirtualJoystick = $CanvasLayer/JoystickLook
@onready var joystick_move: VirtualJoystick = $CanvasLayer/JoystickMove
var rng = RandomNumberGenerator.new()

const L1: Vector3 = Vector3(-28.60, 0.5, 0.874)

const L2: Vector3 = Vector3(30.273, 0.5, 0.874)

const L3: Vector3 = Vector3(-44.815, 0.5, 11.962)

const L4: Vector3 = Vector3(20.22, 0.5, -41.389)

const dfL: Vector3 = Vector3(13.827, 0.5, 25.19)

const SPAWN_AREA_SIZE = 50.0
const MIN_DISTANCE = 30.0

@export var item_scene = preload("res://Main/perfume.tscn")
@export var item_count := 36
@export var map_bounds := Vector3(50, 0, 50) 
@export var item_radius := 2.5

@export var count: int
var fistTime9: bool = true
var fistTime18: bool = true
var fistTime30: bool = true
var fistTime34: bool = true

func _ready():
	if not (OS.get_name() == "Android" or OS.get_name() == "iOS"):
		joystick_look.visible = false
		joystick_move.visible = false
	count = 0;
	rng.randomize()
	spawn_items()
	var random_number = rng.randi_range(1, 4)
	match random_number:
		1:
			player.global_transform.origin = L1
		2:
			player.global_transform.origin = L2
		3:
			player.global_transform.origin = L3

		4:
			player.global_transform.origin = L4
	mr_fat_man.global_transform.origin = dfL

func _physics_process(delta: float):
	var target = player.global_transform.origin
	mr_fat_man.update_target_location(target)
	var vec: Vector2 = joystick_look.output 
	if vec.length() > 0.1:
		player.update_look_input(vec * delta) 
	if(fistTime9 && count == 9): 
		mr_fat_man.update_speed(4.25)
		fistTime9 = false
	if(fistTime18 && count == 18): 
		mr_fat_man.update_speed(4.5)
		fistTime18 = false
	if(fistTime30 && count == 30): 
		mr_fat_man.update_speed(4.75)
		fistTime30 = false
	if(fistTime34 && count == 34): 
		mr_fat_man.update_speed(5.25)
		fistTime34 = false
	if(count == 36):
		call_deferred("_go_to_win_scene")

func _go_to_win_scene():
	get_tree().change_scene_to_file("res://Win/Win.tscn")

func get_free_position(radius: float = 1.0, max_attempts: int = 20) -> Vector3:
	var space_state = get_world_3d().direct_space_state
	
	for i in max_attempts:
		var pos = Vector3(
			randf() * map_bounds.x * 2 - map_bounds.x,
			2,
			randf() * map_bounds.z * 2 - map_bounds.z
		)

		var shape = SphereShape3D.new()
		shape.radius = radius

		# Tạo params
		var params = PhysicsShapeQueryParameters3D.new()
		params.shape = shape
		params.transform = Transform3D(Basis(), pos)
		params.collide_with_bodies = true
		params.collide_with_areas = true

		# Kiểm tra va chạm
		var collisions = space_state.intersect_shape(params)
		if collisions.is_empty():
			return pos

	return Vector3(
		randf() * map_bounds.x * 2 - map_bounds.x,
		0,
		randf() * map_bounds.z * 2 - map_bounds.z
	)


# Spawn tất cả item
func spawn_items():
	for i in item_count:
		var item = item_scene.instantiate()
		item.position = get_free_position(item_radius)
		add_child(item)
		item.connect("picked_up", Callable(self, "_on_item_picked_up"))

# Callback khi Player nhặt vật phẩm
func _on_item_picked_up(player):
	count=count+1

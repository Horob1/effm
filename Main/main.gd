extends Node3D
@onready var mr_fat_man: CharacterBody3D = $MrFatMan
@onready var player: CharacterBody3D = $Player
@onready var joystick_look: VirtualJoystick = $CanvasLayer/JoystickLook
@onready var joystick_move: VirtualJoystick = $CanvasLayer/JoystickMove

const SPAWN_AREA_SIZE = 200.0
const MIN_DISTANCE = 30.0

func _ready():
	if not (OS.get_name() == "Android" or OS.get_name() == "iOS"):
		joystick_look.visible = false
		joystick_move.visible = false
	#spawn_objects_randomly()

func _physics_process(delta: float):
	mr_fat_man.update_target_location(player.global_transform.origin)
	var vec: Vector2 = joystick_look.output 
	if vec.length() > 0.1:
		player.update_look_input(vec * delta) 

func spawn_objects_randomly():
	var player_pos = get_random_position()
	var mr_fat_man_pos = get_valid_position_for_second_object(player_pos)
	
	# Đặt vị trí cho Player
	player.global_position = player_pos
	print("Player spawned at: ", player_pos)
	
	# Đặt vị trí cho MrFatMan
	mr_fat_man.global_position = mr_fat_man_pos
	print("MrFatMan spawned at: ", mr_fat_man_pos)
	
	# In khoảng cách giữa 2 vật thể để kiểm tra
	var distance = player_pos.distance_to(mr_fat_man_pos)
	print("Distance between objects: ", distance, "m")

func get_random_position() -> Vector3:
	var x = randf_range(-SPAWN_AREA_SIZE/2, SPAWN_AREA_SIZE/2)
	var z = randf_range(-SPAWN_AREA_SIZE/2, SPAWN_AREA_SIZE/2)
	var y = 0.0  # Có thể điều chỉnh độ cao nếu cần
	
	return Vector3(x, y, z)

func get_valid_position_for_second_object(first_pos: Vector3) -> Vector3:
	var attempts = 0
	var max_attempts = 100  # Tránh vòng lặp vô tận
	
	while attempts < max_attempts:
		var new_pos = get_random_position()
		var distance = first_pos.distance_to(new_pos)
		
		# Kiểm tra nếu khoảng cách >= MIN_DISTANCE
		if distance >= MIN_DISTANCE:
			return new_pos
		
		attempts += 1
	
	# Nếu không tìm được vị trí hợp lệ sau max_attempts lần thử
	# Tạo vị trí đảm bảo khoảng cách tối thiểu
	return get_guaranteed_distant_position(first_pos)

func get_guaranteed_distant_position(reference_pos: Vector3) -> Vector3:
	# Tạo một vector hướng ngẫu nhiên
	var angle = randf() * 2 * PI
	var direction = Vector3(cos(angle), 0, sin(angle))
	
	# Tính vị trí mới với khoảng cách tối thiểu
	var new_pos = reference_pos + direction * MIN_DISTANCE * 1.1  # 1.1 để đảm bảo > MIN_DISTANCE
	
	# Đảm bảo vị trí mới vẫn trong khu vực spawn
	new_pos.x = clamp(new_pos.x, -SPAWN_AREA_SIZE/2, SPAWN_AREA_SIZE/2)
	new_pos.z = clamp(new_pos.z, -SPAWN_AREA_SIZE/2, SPAWN_AREA_SIZE/2)
	
	return new_pos

# Hàm để respawn lại các vật thể (có thể gọi từ UI hoặc input)
func respawn_objects():
	spawn_objects_randomly()

# Optional: Kiểm tra va chạm với các vật thể khác
func is_position_clear(pos: Vector3, check_radius: float = 2.0) -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	
	# Tạo sphere shape để kiểm tra
	var sphere = SphereShape3D.new()
	sphere.radius = check_radius
	query.shape = sphere
	query.transform.origin = pos
	
	# Kiểm tra va chạm
	var result = space_state.intersect_shape(query)
	return result.is_empty()

# Phiên bản nâng cao với kiểm tra va chạm
func get_valid_position_with_collision_check(first_pos: Vector3) -> Vector3:
	var attempts = 0
	var max_attempts = 200
	
	while attempts < max_attempts:
		var new_pos = get_random_position()
		var distance = first_pos.distance_to(new_pos)
		
		# Kiểm tra khoảng cách và va chạm
		if distance >= MIN_DISTANCE and is_position_clear(new_pos):
			return new_pos
		
		attempts += 1
	
	# Fallback nếu không tìm được vị trí
	return get_guaranteed_distant_position(first_pos)

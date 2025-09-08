extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var SPEED = 4
var ROTATION_SPEED = 5.0

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	if new_velocity.length() > 0.1:
		var target_direction = Vector3(new_velocity.x, 0, new_velocity.z).normalized()
		if target_direction.length() > 0:
			var target_rotation = atan2(target_direction.x, target_direction.z)
			var current_rotation = rotation.y
			var angle_diff = fmod(target_rotation - current_rotation + PI, TAU) - PI
			
			rotation.y += angle_diff * ROTATION_SPEED * delta
	
	nav_agent.set_velocity(new_velocity)

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
func _on_navigation_agent_3d_target_reached() -> void:
	call_deferred("_go_to_lose_scene")

func _go_to_lose_scene():
	get_tree().change_scene_to_file("res://Lose/Lose.tscn")

func update_speed(speed: int):
	SPEED = speed

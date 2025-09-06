extends Node3D
@onready var mr_fat_man: CharacterBody3D = $MrFatMan
@onready var player: CharacterBody3D = $Player
func _physics_process(delta: float):
	mr_fat_man.update_target_location(player.global_transform.origin)

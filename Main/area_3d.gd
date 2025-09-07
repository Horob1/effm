extends Area3D

signal picked_up(player)

@export var player_group_name := "Player"
@onready var model: Node3D = $Model

@export var glow_color: Color = Color(1, 1, 0)
@export var glow_energy: float = 2.0
@export var rotation_speed: float = 30.0  

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	_make_model_glow(model)

func _process(delta: float) -> void:
	model.rotate_y(deg_to_rad(rotation_speed * delta))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(player_group_name):
		emit_signal("picked_up", body)
		queue_free()

func _make_model_glow(item: Node3D):
	for mesh_instance in _get_meshes_recursive(item):
		var mesh = mesh_instance.mesh
		if mesh and mesh is ArrayMesh:
			for i in range(mesh.get_surface_count()):
				var mat = mesh.surface_get_material(i)
				if mat and mat is StandardMaterial3D:
					mat = mat.duplicate()
					mat.emission_enabled = true
					mat.emission = glow_color
					mat.emission_energy = glow_energy
					mesh.surface_set_material(i, mat)


func _get_meshes_recursive(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		if child is MeshInstance3D:
			result.append(child)
		elif child is Node3D:
			result += _get_meshes_recursive(child)
	return result

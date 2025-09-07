extends Node2D

@onready var replay_button: TouchScreenButton = $TouchScreenButton

func _ready():
	replay_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")

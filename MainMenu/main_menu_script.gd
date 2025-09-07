extends Node

@onready var play_button: TouchScreenButton = $PlayButton
@onready var btn: Button = $PlayButton/Button

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	btn.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")

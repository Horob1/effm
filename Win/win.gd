extends Node2D
@onready var replay: TouchScreenButton = $Replay
@onready var exit: TouchScreenButton = $Exit

func _ready():
	replay.pressed.connect(Callable(self, "_on_replay_pressed"))
	exit.pressed.connect(Callable(self, "_on_exit_pressed"))

func _on_replay_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")
	

# Callback khi nhấn Exit
func _on_exit_pressed():
	get_tree().quit()

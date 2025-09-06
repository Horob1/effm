extends Node

@onready var play_button: Button = $Menu/PlayButton
@onready var setting_button: Button = $Menu/SettingButton
@onready var easy_button: Button = $DifficultyPopup/DifficultyPicker/EasyButton
@onready var normal_button: Button = $DifficultyPopup/DifficultyPicker/NormalButton
@onready var hard_button: Button = $DifficultyPopup/DifficultyPicker/HardButton
@onready var difficulty_popup: Popup = $DifficultyPopup

var difficulty: int = 0

# Config lưu setting
var config := ConfigFile.new()
const SAVE_PATH := "user://settings.cfg"

func _ready():
	load_difficulty()
	highlight_selected()

	play_button.pressed.connect(_on_play_pressed)
	setting_button.pressed.connect(_on_setting_pressed)
	easy_button.pressed.connect(_on_easy_pressed)
	normal_button.pressed.connect(_on_normal_pressed)
	hard_button.pressed.connect(_on_hard_pressed)

# --- Save / Load ---
func save_difficulty():
	config.set_value("game", "difficulty", difficulty)
	config.save(SAVE_PATH)

func load_difficulty():
	var err = config.load(SAVE_PATH)
	if err == OK:
		difficulty = config.get_value("game", "difficulty", 0)
	else:
		difficulty = 0

# --- Highlight nút ---
func reset_button_colors():
	easy_button.modulate = Color.WHITE
	normal_button.modulate = Color.WHITE
	hard_button.modulate = Color.WHITE

func highlight_selected():
	reset_button_colors()
	match difficulty:
		0:
			easy_button.modulate = Color.GREEN
		1:
			normal_button.modulate = Color.GREEN
		2:
			hard_button.modulate = Color.GREEN

# --- Button events ---
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Main/Main.tscn")

func _on_setting_pressed():
	difficulty_popup.popup_centered()

func _on_easy_pressed():
	difficulty = 0
	highlight_selected()
	save_difficulty()
	difficulty_popup.hide()

func _on_normal_pressed():
	difficulty = 1
	highlight_selected()
	save_difficulty()
	difficulty_popup.hide()

func _on_hard_pressed():
	difficulty = 2
	highlight_selected()
	save_difficulty()
	difficulty_popup.hide()

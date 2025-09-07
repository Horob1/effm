extends CanvasLayer

@onready var label = $CountLabel

func _process(delta):
	# Lấy biến count từ cha
	var parent_count = get_parent().count
	label.text = str(parent_count)

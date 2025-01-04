extends Control

var data : Dictionary

func _ready() -> void:
	focus_entered.connect(gain_focus)
	focus_exited.connect(lose_focus)
	mouse_entered.connect(grab_focus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	custom_minimum_size.y = $Container/Text.size.y + 10
	custom_minimum_size.x = $Container/Text.size.x
	
func set_data(_data: Dictionary):
	data = _data
	$Container/Text.text = data.text

func mouse_hover() -> void:
	print("that")

func gain_focus() -> void:
	var style_box = $Container.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style_box.bg_color = Color.RED
	$Container.add_theme_stylebox_override("panel", style_box)

func lose_focus() -> void:
	var style_box = $Container.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style_box.bg_color = Color.hex(0x999999)
	$Container.add_theme_stylebox_override("panel", style_box)

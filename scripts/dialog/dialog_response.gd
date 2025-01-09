extends Control

var data : Dictionary
var game_manager
func _ready() -> void:
	focus_entered.connect(gain_focus)
	focus_exited.connect(lose_focus)
	mouse_entered.connect(grab_focus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	custom_minimum_size.y = $Container/Text.size.y + 10
	custom_minimum_size.x = $Container/Text.size.x
	
func set_data(_data: Dictionary, _game_manager):
	data = _data
	if data.has("text"):
		$Container/Text.text = data.text
	game_manager = _game_manager
	if data.has("requirements"):
		if not check_requirements(data.requirements):
			set_disabled()

func check_requirements(requirements: Array) -> bool:
	for requirement in requirements:
		if typeof(requirement.key) == TYPE_STRING:
			if requirement.key == "true":
				requirement.key = true
		if typeof(requirement.value) == TYPE_STRING:
			if requirement.value == "true":
				requirement.value = true
		match requirement.type:
			"less":
				if not game_manager.get_game_state(requirement.key) < requirement.value:
					return false
			"greater":
				if not game_manager.get_game_state(requirement.key) > requirement.value:
					return false
			"equal":
				if not game_manager.get_game_state(requirement.key) == requirement.value:
					return false
			_:
				push_error("Unkown requirement for response " + data.text)
	return true


func mouse_hover() -> void:
	print("that")

func gain_focus() -> void:
	var style_box = $Container.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style_box.bg_color = Color.RED
	$Container.add_theme_stylebox_override("panel", style_box)

func lose_focus() -> void:
	var style_box = $Container.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style_box.bg_color = Color.hex(0x999999ff)
	$Container.add_theme_stylebox_override("panel", style_box)

func set_disabled() -> void:
	focus_mode = FocusMode.FOCUS_NONE
	var style_box = $Container.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style_box.bg_color = Color.hex(0x555555ff)
	$Container.add_theme_stylebox_override("panel", style_box)

extends Node

var game_state : Dictionary


func update_relation(speaker, value):
	if not game_state.has(speaker):
		game_state[speaker] = 0	
	game_state[speaker] += value

func set_game_state(key, value):
	game_state[key] = value

func get_game_state(key):
	if game_state.has(key):
		return game_state[key]
	return null

signal open_dialog_scene(name: String)
signal close_dialog(name: String)

@onready var menu = get_node("/root/PauseMenu")
var menu_state : bool

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			menu.visible = not menu.visible
			menu_state = menu.visible
#		if event.is_action_pressed("ui_text_newline"):
#			emit_signal("open_dialog_scene", "test")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

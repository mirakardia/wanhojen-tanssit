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

func open_scene(name: String):
	emit_signal("open_scene", name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

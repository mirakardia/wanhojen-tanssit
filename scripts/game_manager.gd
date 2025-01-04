extends Node

var game_state : Dictionary


func update_relation(speaker, value):
	game_state[speaker] += value

func set_game_state(key, value):
	game_state[key] = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

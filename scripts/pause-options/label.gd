extends Label

@export
var item: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if GameManager.get_game_state(item) == true:
		visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

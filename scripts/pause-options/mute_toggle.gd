extends CheckButton

@export
var bus_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggled.connect(_on_toggled)
	GameManager.set_game_state("kuvisjuoru",true)
	GameManager.set_game_state("levy",true)
	GameManager.set_game_state("kakka",true)
	
func _on_toggled(toggled_on: bool) -> void:
	SoundManager.set_mute(toggled_on, bus_name)
	

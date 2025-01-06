extends "res://scripts/pause-options/volume_slider.gd"


var gibberish_counter: int = 0

func _process(_delta: float) -> void:
	if gibberish_counter > 0:
		SoundManager.speak_gibberish()
		SoundManager.set_gibberish_profile("sakari")
		gibberish_counter -= 1
# Called when the node enters the scene tree for the first time.
func _on_value_changed(_value: float) -> void:
	gibberish_counter = 20
	SoundManager.set_volume(value, bus_name)

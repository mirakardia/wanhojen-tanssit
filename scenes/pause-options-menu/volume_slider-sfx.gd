extends "res://scripts/pause-options/volume_slider.gd"


# Called when the node enters the scene tree for the first time.
func _on_value_changed(_value: float) -> void:
	SoundManager.test_sfx()
	SoundManager.set_volume(value, bus_name)
	pass

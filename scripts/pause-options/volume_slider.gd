extends HSlider

@export
var bus_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = SoundManager.get_volume(bus_name)
	value_changed.connect(_on_value_changed)
	

func _on_value_changed(value: float) -> void:
	SoundManager.set_volume(value, bus_name)
# Called every frame. 'delta' is the elapsed time since the previous frame.

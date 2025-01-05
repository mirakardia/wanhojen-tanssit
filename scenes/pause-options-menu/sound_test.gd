extends Button

@export
var test_audio: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	match test_audio:
		"sfx":
			SoundManager.test_sfx()
		"bgm":
			SoundManager.play_bgm("bgm_sakari")
		"speech":
			SoundManager.speak_gibberish()
# Called every frame. 'delta' is the elapsed time since the previous frame.

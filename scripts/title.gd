extends TextureRect
@onready var player: Player = $"../Player"
var title: bool = true

func _ready() -> void:
	SoundManager.play_bgm("bgm_title")
	player.disable_movement("")
	player.visible = false

func _input(event: InputEvent) -> void:
	if title:
		if event is InputEventKey:
			if event.is_action_pressed("ui_accept"):
				visible = false
				player.enable_movement("")
				SoundManager.play_bgm("bgm_overworld")
				player.visible = true
				title = false

@tool
extends Node


@onready var hitbox : Area2D = get_node("Hitbox")
@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var game_manager : GameManager = get_node("/root/GameManager")

enum INTERACTION_TYPE {DIALOG, CHANGE_STATE, CHANGE_SCENE, NONE} 
var type : INTERACTION_TYPE:
	set (s):
		type = s
		notify_property_list_changed()


var dialog : String
var scene : Vector2

var key : String
var value : String

var sprite_sheet : Texture
var spirte_hframes : int
var spirte_vframes : int
var sprite_anim_start :int
var sprite_anim_end :int
var sprite_anim_speed: float = 1
func _ready() -> void:
	hitbox.body_entered.connect(enter_interactable)
	hitbox.body_exited.connect(exit_interactable)
	sprite.texture = sprite_sheet
	sprite.vframes = spirte_vframes
	sprite.hframes = spirte_hframes
	anim()


func enter_interactable(body : Node2D):
	if body.get_groups().has("player"):
		print("test")
		game_manager.interaction_events.append(event)

func anim() -> void:
	var tween = sprite.create_tween()
	sprite.frame = sprite_anim_start
	tween.tween_property(sprite, "frame", sprite_anim_end, sprite_anim_speed)
	tween.tween_callback(anim)

func event():
	match type:
		INTERACTION_TYPE.DIALOG:
			game_manager.emit_signal("open_dialog_scene", dialog)
			type = INTERACTION_TYPE.NONE
		INTERACTION_TYPE.CHANGE_STATE:
			game_manager.set_game_state(key, value)
			SoundManager.test_sfx()
		INTERACTION_TYPE.CHANGE_SCENE:
			game_manager.change_scene(scene)


func exit_interactable(body : Node2D):
	if body.get_groups().has("player"):
		game_manager.interaction_events.erase(event)


func _get_property_list():
	if Engine.is_editor_hint(): # Use this if you make a @tool.
		var ret = []
		ret.append({
			  "name": &"type", # Note the g0_ here. It's ugly, but meh.
			  "type": TYPE_INT,
			  "usage": PROPERTY_USAGE_DEFAULT,
			  "hint": PROPERTY_HINT_ENUM,
			  "hint_string": ",".join(INTERACTION_TYPE.keys())
		 	  })

		if type == INTERACTION_TYPE.DIALOG:
			ret.append({
			"name": &"dialog",
			"type": TYPE_STRING,
			"hint": PROPERTY_USAGE_DEFAULT,
		 	})

		if type == INTERACTION_TYPE.CHANGE_STATE:
			ret.append({
			"name": &"key",
			"type": TYPE_STRING,
			"hint": PROPERTY_USAGE_DEFAULT,
		 	})
			ret.append({
			"name": &"value",
			"type": TYPE_STRING,
			"hint": PROPERTY_USAGE_DEFAULT,
		 	})
		if type == INTERACTION_TYPE.CHANGE_SCENE:
			ret.append({
			"name": &"scene",
			"type": TYPE_VECTOR2,
			"hint": PROPERTY_USAGE_DEFAULT
		 	})
		ret.append({
			"name": &"sprite_sheet",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "Texture2D"
		 	})
		ret.append({
			"name": &"spirte_hframes",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
		ret.append({
			"name": &"spirte_vframes",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT
		})
		ret.append({
			"name": &"sprite_anim_start",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		ret.append({
			"name": &"sprite_anim_end",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		ret.append({
			"name": &"sprite_anim_speed",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
		})
		return ret

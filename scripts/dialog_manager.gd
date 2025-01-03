extends Node


@export var dialogue_root : Node

@onready var dialogue_box : Node = dialogue_root.get_node("DialogBox")

var dialog_data: Dictionary

func _ready() -> void:
    pass

func start_scene (scene_name: String) -> void:
    var file = FileAccess.get_file_as_string("res://assets/dialogs"+scene_name+".json")
    dialog_data = JSON.parse_string(file)

func find_dialog(dialog_name: String) -> Dictionary:
    for dialog in dialog_data.dialog :
        if dialog.name == dialog_name:
            return dialog

    return {}
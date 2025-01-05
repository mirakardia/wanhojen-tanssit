extends Node


@export var dialog_root : Node

@onready var dialog_box : RichTextLabel = dialog_root.get_node("DialogBox")
#@onready var speaker_icon : Node = dialog_root.get_node("SpeakerIcon")
@onready var speaker_label : RichTextLabel = dialog_root.get_node("SpeakerLabel")
@onready var response_list : Control = dialog_root.get_node("Scroll/Responses")
#@onready var background : Node = dialog_root.get_node("Backgroudn")

const response_scene = preload("res://scenes/response.tscn")

var dialog_data: Dictionary
var current_dialog: Dictionary

var participants : Dictionary

var text_speed : int = 1

func _ready() -> void:
	start_scene("test")
	start_dialog(dialog_data.start)

func _process(_delta: float) -> void:
	if dialog_box.visible_ratio < 1:
		dialog_box.visible_characters += text_speed
		
		SoundManager.speak_gibberish()
		
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			skip_or_next()
		if event.is_action_pressed("ui_cancel"):
			dialog_box.visible_ratio = 1

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			skip_or_next()
			
func skip_or_next() -> void:
	if dialog_box.visible:
		if dialog_box.visible_ratio < 1:
				dialog_box.visible_ratio = 1
		else:
			if current_dialog.has("next") and current_dialog.has("responses"):
				push_error("Has both next and responses in dialog " + current_dialog.name)
			if current_dialog.has("next"):
				start_dialog(current_dialog.next)
			elif current_dialog.has("responses"):
				show_responses(current_dialog.responses)
			else:
				end_dialog()
	elif response_list.visible:
		var response_data = get_viewport().gui_get_focus_owner().data
		if response_data.has("next"):
			start_dialog(response_data.next)
		else:
			end_dialog()

func start_scene (scene_name: String) -> void:
	var file = FileAccess.get_file_as_string("res://assets/dialogs/"+scene_name+".json")
	dialog_data = JSON.parse_string(file)

func find_dialog(dialog_name: String) -> Dictionary:
	for dialog in dialog_data.dialog:
		if dialog.name == dialog_name:
			return dialog
	push_error("Couldn't find dialog with name: " + dialog_name)
	return {}

func start_dialog (dialog_name: String) -> void:
	var dialog = find_dialog(dialog_name)
	current_dialog = dialog
	dialog_box.visible = true
	response_list.visible = false
	run_effects(dialog.effects)
	set_active_speaker(dialog.speaker)
	dialog_box.text = dialog.text
	dialog_box.visible_ratio = 0
	pass

func end_dialog() -> void:
	print("ending dialog")

func set_active_speaker(speaker : String) -> void:
	speaker_label.text = speaker
	for participant in participants:
		participant.set_deactive()

	if participants.has(speaker):
		participants[speaker].set_active()

func run_effects (effects: Array) -> void:
	pass


func show_responses (responses: Array) -> void:
	dialog_box.visible = false
	response_list.visible = true
	set_active_speaker("Sinä")
	for child in response_list.get_children() :
		child.call("free")

	for response in responses:
		var instant = response_scene.instantiate()
		instant.set_data(response)
		response_list.add_child(instant)
	response_list.get_child(0).grab_focus()

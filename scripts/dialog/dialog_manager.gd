extends Node


@export var dialog_root : Node
@export var speaker_icons: Dictionary


@onready var dialog_box : RichTextLabel = dialog_root.get_node("DialogBox")
@onready var speaker_icon : TextureRect = dialog_root.get_node("SpeakerIcon")
@onready var speaker_label : RichTextLabel = dialog_root.get_node("SpeakerLabel")
@onready var response_list : Control = dialog_root.get_node("Scroll/Responses")
@onready var participant_line : Line2D = dialog_root.get_node("ParticipantRow")
@onready var game_manager : Node = get_node("/root/GameManager")
#@onready var background : Node = dialog_root.get_node("Backgroudn")


const response_scene = preload("res://scenes/response.tscn")
const participant_scene = preload("res://scenes/participant.tscn")
var dialog_data: Dictionary
var current_dialog: Dictionary

var participants : Dictionary
var current_participants : Dictionary

var text_speed : int = 1

var in_dialog: bool = false

func _ready() -> void:
	load_participant_data()
	game_manager.open_dialog_scene.connect(start_scene)

	game_manager.emit_signal("open_dialog_scene","test")
	


func load_participant_data() -> void:
	const dir = "res://assets/data/participant"
	var participant_dir = DirAccess.open(dir)
	for file in participant_dir.get_files():
		var data = FileAccess.get_file_as_string(dir+"/"+file)
		var json = JSON.parse_string(data)
		
		for emote in json.emotes.keys():
			var emote_image = Image.load_from_file(json.emotes[emote])
			var emote_texture = ImageTexture.create_from_image(emote_image)
			json.emotes[emote] = emote_texture
		
		json.reaction_origin = Vector2(json.reaction_origin.x,json.reaction_origin.y)



		participants[file.trim_suffix(".json")] = json



func _process(_delta: float) -> void:
	if dialog_box.visible_ratio < 1:
		dialog_box.visible_characters += text_speed
		
		SoundManager.speak_gibberish()
		
func _input(event: InputEvent) -> void:
	if not in_dialog:
		return
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
		
		if response_data.has("reactions"):
			update_reactions(response_data.reactions)
		if response_data.has("next"):
			start_dialog(response_data.next)
		else:
			end_dialog()

func start_scene (scene_name: String) -> void:
	var file = FileAccess.get_file_as_string("res://assets/dialogs/"+scene_name+".json")
	dialog_data = JSON.parse_string(file)
	var tween = dialog_root.create_tween()
	tween.tween_property(dialog_root, "modulate", Color.WHITE, 1)
	tween.tween_callback(start_dialog.bind(dialog_data.start))


func find_dialog(dialog_name: String) -> Dictionary:
	for dialog in dialog_data.dialog:
		if dialog.name == dialog_name:
			return dialog
	push_error("Couldn't find dialog with name: " + dialog_name)
	return {}
const player_name = "Minä"

func start_dialog (dialog_name: String) -> void:
	print("test")
	var dialog = find_dialog(dialog_name)
	in_dialog = true;
	current_dialog = dialog
	dialog_box.visible = true
	response_list.visible = false
	if dialog.has("effects"):
		run_effects(dialog.effects)
	set_active_speaker(dialog.speaker)
	dialog_box.text = dialog.text.replace("%s", player_name)
	dialog_box.visible_ratio = 0
	pass

func end_dialog() -> void:
	var tween = dialog_root.create_tween()
	var transparent_white = Color(1,1,1,0)
	in_dialog = false
	tween.tween_property(dialog_root, "modulate", transparent_white, 1)
	tween.tween_callback(cleanup_participants)
	tween.tween_callback(game_manager.emit_signal.bind("close_dialog", current_dialog.name))
	
func cleanup_participants() -> void:
	for participant in current_participants.keys():
		current_participants[participant].call_deferred("free")
		current_participants.erase(participant)

func set_active_speaker(speaker : String) -> void:

	speaker_label.text = speaker.replace("%s", player_name)
	if participants.has(speaker):
		if participants[speaker].has("name"):
			speaker_label.text = participants[speaker].name
			SoundManager.set_gibberish_profile(participants[speaker].name)
		else:
			SoundManager.set_gibberish_profile()
	if speaker_icons.has(speaker):
		speaker_icon.texture = speaker_icons[speaker]
	else: 
		speaker_icon.texture = null
	for participant in current_participants:
		current_participants[participant].set_deactive()

	if current_participants.has(speaker):
		current_participants[speaker].set_active()

func run_effects (effects: Array) -> void:
	for effect in effects:
		if effect.has("type"):
			match effect.type:
				"join_conversation":
					add_participant(effect.actor)
				"leave_conversation":
					remove_participant(effect.actor)
				"emote":
					change_participant_emote(effect.actor, effect.emote)
				"reactions":
					update_reactions(effect.reactions)
				"change_state":
					game_manager.set_game_state(effect.key, effect.value)
				"play_bgm":
					SoundManager.play_bgm(effect.track)
				"stop_bgm":
					SoundManager.stop_bgm()
				"set_gibberish_profile":
					SoundManager.set_gibberish_profile(effect.profile)
				_:
					push_error("Unknown Effect at dialog" + current_dialog.name)
		else:
			push_error("Invalid effect object at dialog" + current_dialog.name)
	pass

func add_participant(participant: String) -> void:
	if current_participants.has(participant):
		push_error("Cannot add participant that is already in conversation at dialog " + current_dialog.name)
		return
	var instant = participant_scene.instantiate()
	instant.set_data(participants[participant])
	participant_line.add_child(instant)
	current_participants[participant] = instant

	var count = len(current_participants) + 1
	var i : int = 1
	for participant_obj in current_participants.values() :
		if participant_obj.flag:
			participant_obj.position = participant_line.get_point_from_line(1.0/count*i)
		else:
			participant_obj.set_new_pos(participant_line.get_point_from_line(1.0/count*i))
		i += 1

	instant.call_deferred("join_conversation")
	pass

func remove_participant(participant: String) -> void:	
	if not current_participants.has(participant):
		push_error("Cannot remove a participant that is not there in conversation at dialog " + current_dialog.name)
		return

	current_participants[participant].leave_conversation()
	current_participants.erase(participant)
	var count = len(current_participants) + 1
	var i : int = 1
	for participant_obj in current_participants.values() :
		participant_obj.call_deferred("set_new_pos", participant_line.get_point_from_line(1.0/count*i))
		i += 1

func change_participant_emote(patricipant: String, emote: String) -> void:
	if not current_participants.has(patricipant):
		push_error("Cannot change emote of character not present in dialog " + current_dialog.name)
		return
	current_participants[patricipant].change_emote(emote)


func show_responses (responses: Array) -> void:
	dialog_box.visible = false
	response_list.visible = true
	set_active_speaker("%s")

	for child in response_list.get_children() :
		child.call("free")

	for response in responses:
		var instant = response_scene.instantiate()
		instant.set_data(response, game_manager)
		response_list.add_child(instant)

	for child : Control in response_list.get_children():
		if not child.focus_mode == Control.FocusMode.FOCUS_NONE:
			child.grab_focus()
			break
func update_reactions(reactions: Dictionary):
	for participant in reactions.keys():
		game_manager.update_relation(participant, reactions[participant])
		if current_participants.has(participant):
			current_participants[participant].show_relation_update(reactions[participant])	
		

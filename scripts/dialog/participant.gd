extends Node


var data : Dictionary
var dest_color : Color = Color.WHITE
func set_data(_data: Dictionary):
	data = _data
	$Offset/Portrait.texture = data.emotes[data.neutral]
	$Offset.position.y = data.offset

@export var quite_color: Color = Color.WHITE
@export var jump : Vector2
var flag : bool = true

func set_new_pos(new_pos: Vector2) -> void:
	if flag:
		return
	var tween = create_tween()
	tween.tween_property(self, "position", new_pos, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT) 

func set_deactive() -> void:
	var tween = create_tween()
	dest_color = quite_color
	tween.tween_property($Offset/Portrait, "modulate", dest_color, 0.1)

func set_active() -> void:
	if flag:
		dest_color = Color.WHITE
		return

	var tween = create_tween()
	var posA = $Offset.position
	var posB = $Offset.position - jump
	dest_color = Color.WHITE

	tween.tween_property($Offset/Portrait, "modulate", dest_color, 0.1)
	tween.parallel().tween_property($Offset, "position", posB, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property($Offset, "position", posA, 0.1).set_ease(Tween.EASE_IN)
	pass

func generate_radom_angle(angles, cutoff) -> float:
	var random_angle = randf_range(-50,50) - 90
	if cutoff < 50:
		for angle in angles:
			if rad_to_deg(angle_difference(deg_to_rad(random_angle), angle)) < 20:
				return generate_radom_angle(angles,cutoff+1)
	return random_angle
				

func show_relation_update(value) -> void:
	var reaction_image : Image
	if value < 0:
		reaction_image = Image.load_from_file("res://assets/sprites/reactions/negative.png")
	else: 
		reaction_image = Image.load_from_file("res://assets/sprites/reactions/positive.png")
	var reaction_texture = ImageTexture.create_from_image(reaction_image)
	var angles = []
	for i in range(abs(value)):
		var reaction_instant = TextureRect.new()
		reaction_instant.texture = reaction_texture
		reaction_instant.z_index = 1

		reaction_instant.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		reaction_instant.size = Vector2.ONE * 10
		reaction_instant.pivot_offset.x = 5 

		var random_angle = generate_radom_angle(angles,0)
		angles.append(deg_to_rad(random_angle))
		
		reaction_instant.position = data.reaction_origin + Vector2(cos(deg_to_rad(random_angle)), sin(deg_to_rad(random_angle))) * 30
		add_child(reaction_instant)
		var tween = reaction_instant.create_tween()
		var speed = randf_range(0.5, 1)
		var distance = randf_range(80, 120)
		var new_pos = reaction_instant.position + Vector2(cos(deg_to_rad(random_angle)), sin(deg_to_rad(random_angle)))*distance

		tween.tween_property(reaction_instant, "position", new_pos, speed)
		tween.parallel().tween_property(reaction_instant, "rotation", deg_to_rad((random_angle+90)/2), speed)
		tween.parallel().tween_property(reaction_instant, "scale", Vector2.ONE*10, speed)
		tween.tween_callback(reaction_instant.free)

func join_conversation() -> void:
	flag = false
	$Offset/Portrait.modulate = dest_color
	$Offset/Portrait.modulate.a = 0
	var pos = $Offset/Portrait.position	
	$Offset/Portrait.position.y += 100	
	
	var tween = create_tween()
	tween.tween_property($Offset/Portrait, "position", pos, 0.5)
	tween.parallel().tween_property($Offset/Portrait, "modulate", dest_color, 0.5)
	tween.tween_interval(1)
	pass

func leave_conversation() -> void:
	flag = true
	dest_color.a = 0
	self.z_index = -1
	var pos = $Offset/Portrait.position	
	pos.y += 100	
	
	var tween = create_tween()
	tween.tween_property($Offset/Portrait, "position", pos, 0.3)
	tween.parallel().tween_property($Offset/Portrait, "modulate", dest_color, 0.3)

	pass

func change_emote(emote: String):
	if not data.emotes.has(emote):
		push_error("Unkown emote " + emote)
		return
	$Offset/Portrait.texture = data.emotes[emote]

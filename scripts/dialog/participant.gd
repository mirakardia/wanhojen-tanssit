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

func show_relation_update(value) -> void:
	pass

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
	tween.tween_property($Offset/Portrait, "position", pos, 0.5)
	tween.parallel().tween_property($Offset/Portrait, "modulate", dest_color, 0.5)

	pass

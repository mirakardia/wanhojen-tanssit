class_name Player extends CharacterBody2D

var cardinal : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var game_manager = get_node("/root/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.init(self)
	game_manager.open_dialog_scene.connect(disable_movement)
	game_manager.close_dialog.connect(enable_movement)

func disable_movement(_s):
	state_machine.disable_movement = true or game_manager.menu_state


func enable_movement(_s):
	state_machine.disable_movement = false or game_manager.menu_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Get direction vector from the input axes.
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))

	# Normalize the direction vectors.
	direction = direction.normalized()


# Called every physics frame.
func _physics_process(_delta: float) -> void:
	move_and_slide()


# Determine if a new direction should be set.
func set_direction() -> bool:
	var new_direction : Vector2 = cardinal

	# No need to set a new direction if the direction is a zero vector.
	if direction == Vector2.ZERO:
		return false
	
	if abs(direction.x) > abs(direction.y):
		new_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		new_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP

	# No need to set a new direction if no change was made.
	if new_direction == cardinal: 
		return false
	else:
		# Set a new cardinal direction and flip the sprite if necessary.
		cardinal = new_direction
		sprite.scale.x = -1 if cardinal == Vector2.LEFT else 1
		return true


# Get a string representation for the animation direction.
func get_animation_direction() -> String:
	if cardinal == Vector2.UP:
		return "up"
	elif cardinal == Vector2.DOWN:
		return "down"
	else:
		return "side"


# Change the played animation based on player state.
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + get_animation_direction())
	pass

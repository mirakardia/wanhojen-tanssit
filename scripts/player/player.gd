class_name Player extends CharacterBody2D

var cardinal : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.init(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Calculate direction components.
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

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
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
	elif direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT

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

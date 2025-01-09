class_name State_Walk extends State

@export var speed : float = 150.0
@onready var idle : State = $"../Idle"

# Called when the Player enters the State.
func enter() -> void:
	player.update_animation("walk")


# Called during every _process() call for the State.
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	else:
		player.velocity = player.direction * speed

		if player.set_direction():
			player.update_animation("walk")

		return null

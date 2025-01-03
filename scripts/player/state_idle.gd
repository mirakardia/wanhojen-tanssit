class_name State_Idle extends State

@onready var walk : State = $"../Walk"

# Called when the Player enters the State.
func enter() -> void:
    player.update_animation("idle")


# Called during every _process() call for the State.
func process(_delta: float) -> State:
    if player.direction != Vector2.ZERO:
        return walk
    else:
        player.velocity = Vector2.ZERO
        return null

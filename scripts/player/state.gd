class_name State extends Node

# The Player object this State attaches to.
static var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


# Called when the Player enters the State.
func enter() -> void:
    pass


# Called when the Player exits the State.
func exit() -> void:
    pass


# Called during every _process() call for the State.
func process(_delta: float) -> State:
    return null


# Called during every _physics_process() call for the State.
func physics_process(_delta: float) -> State:
    return null


# Handle input events for the State.
func handle_input(_event: InputEvent) -> State:
    return null
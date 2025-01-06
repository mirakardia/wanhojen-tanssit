class_name PlayerStateMachine extends Node

var states : Array[State]
var previous : State
var current : State

var disable_movement : bool
var game_manager 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if disable_movement or game_manager.menu_state:
		return
	set_state(current.process(delta))


# Called every physics frame.
func _physics_process(delta: float) -> void:
	if disable_movement or game_manager.menu_state:
		return
	set_state(current.physics_process(delta))


# Handle input events.
func _unhandled_input(event: InputEvent) -> void:
	if disable_movement or game_manager.menu_state:
		return
	set_state(current.handle_input(event))


func init(_player: Player) -> void:
	states = []
	game_manager = _player.game_manager
	for child in self.get_children():
		if child is State: states.append(child)
	
	if states.size() > 0:
		states[0].player = _player
		set_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func set_state(new_state: State) -> void:
	if new_state == null || new_state == current:
		return
	if current:
		current.exit()

	previous = current
	current = new_state
	current.enter()

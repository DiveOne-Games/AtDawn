class_name StateMachine extends Node

@export var character : CharacterBody2D
@export var initial_state : PlayState
var current_state: PlayState
var states: Dictionary


func init(current_player: CharacterBody2D, animation_player: AnimationPlayer):
	character = current_player
	var available_states = find_children("*", "PlayState", false) as Array[PlayState]
	for state in available_states:
		state.character = character
		state.animator = animation_player
		states[state.name] = state
		#state.transition.connect(_on_state_transition)
	transition(initial_state)


func process(delta: float) -> void:
	var next_state = current_state.process(delta)
	if next_state:
		transition(next_state)
	current_state.process(delta)


func physics_process(delta: float) -> void:
	var next_state = current_state.physics_process(delta)
	if next_state:
		transition(next_state)
	current_state.physics_process(delta)
	

func input(event: InputEvent) -> void:
	var next_state = current_state.input(event)
	if next_state:
		transition(next_state)
	current_state.input(event)


func transition(new_state: PlayState):
	if current_state:
		current_state.end()
	current_state = new_state
	current_state.start()


func _on_state_transition(next_state: String):
	print_debug('Transition received for ', next_state)
	if current_state:
		current_state.end()
	current_state = states.get(next_state, initial_state)
	current_state.start()

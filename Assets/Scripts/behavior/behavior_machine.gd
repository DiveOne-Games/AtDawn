class_name BehaviorMachine extends Node

signal target_acquired(unit: CharacterBody2D)

@export var initial_state: Behavior
@export var current_state: Behavior
@export var animator: AnimationPlayer
@export_category("Special Transitions")
@export var hurt : Behavior
@export var death : Behavior

var character : CharacterBody2D
var target : CharacterBody2D :
	set(unit) : 
		target = unit
		target_acquired.emit(unit)
var behaviors : Array
var behavior_map = {0: 'Idle', 1: 'Patrol'}  # TODO: Difficult to manage


func init(_character: CharacterBody2D, _animator: AnimationPlayer, _init_behavior: int = 0):
	character = _character
	animator = _animator
	initialize_behaviors(_init_behavior)
	update_state(initial_state)


func _process(delta):
	var next_state = current_state.update(delta)
	if next_state:
		update_state(next_state)
	current_state.update(delta)


func _physics_process(delta):
	var next_state = current_state.physics_update(delta)
	if next_state:
		update_state(next_state)
	current_state.physics_update(delta)


func _unhandled_input(event):
	var next_state = current_state.handle_input(event)
	if next_state:
		update_state(next_state)
	current_state.handle_input(event)


func initialize_behaviors(b_init = 0):
	behaviors = find_children("*", "Behavior", false) as Array[Behavior]
	var selected = behavior_map.get(b_init)
	print_debug("Found behaviors: ", behaviors)
	for b in behaviors:
		b.character = character
		b.machine = self
		# Set initial state if selected.
		if selected == b.behavior_name:
			initial_state = b


func update_state(next_state: Behavior):
	var prior: Behavior = null
	if current_state:
		current_state.end()
		prior = current_state
	current_state = next_state
	current_state.start(prior)

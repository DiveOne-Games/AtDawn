class_name Behavior extends Node

@export var behavior_name: String
@export var animation: String
@export var resume := false  ## Resume the previous behavior state.

var character : CharacterBody2D
var previous_state: Behavior
var machine : BehaviorMachine


func start():
	character.animator.play(animation)


func end():
	pass


func update(_delta: float) -> Behavior:
	return null


func physics_update(_delta: float) -> Behavior:
	if character.health <= 0 and not character.is_dead:
		return machine.death
	return null


func handle_input(_event: InputEvent) -> Behavior:
	return null

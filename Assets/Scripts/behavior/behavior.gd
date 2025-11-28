class_name Behavior extends Node

@export var behavior_name: String
@export var animation: String
@export var resume := false  ## Resume the previous behavior state.

var character : CharacterBody2D
var previous_state: Behavior
var machine : BehaviorMachine


func start(old_state: Behavior = null):
	character.animator.play(animation)
	if old_state:
		if not old_state.behavior_name == behavior_name \
		and not old_state == machine.hurt:
			previous_state = old_state


func end():
	await character.animator.animation_finished


func update(_delta: float) -> Behavior:
	return null


func physics_update(_delta: float) -> Behavior:
	return null


func handle_input(_event: InputEvent) -> Behavior:
	return null

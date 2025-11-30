class_name PlayState extends Node

@export var animation: String
@export var character: CharacterBody2D
@export var move_state : MoveState
@export var combat_state : CombatState

var animator: AnimationPlayer
var death_state: PlayState
var hurt_state: PlayState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


## Similar to [method Node._process], but only called discretely instead of every frame.
func process(_delta: float) -> PlayState:
	return null


## Similar to [method Node._physics_process], but only called discretely instead of every frame.
func physics_process(_delta: float) -> PlayState:
	return null


## Similar to [method _unhandled_input], but only called discretely instead of every frame.
func input(_event: InputEvent) -> PlayState:
	return null

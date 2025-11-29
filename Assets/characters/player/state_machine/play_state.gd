class_name PlayState extends Node

@export var animation: String
@export var character: CharacterBody2D
@export var move_state : PlayState
@export var combat_state : CombatState

var animator: AnimationPlayer
var death_state: PlayState
var hurt_state: PlayState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


func process(_delta: float) -> PlayState:
	return null


func physics_process(_delta: float) -> PlayState:
	return null


func input(_event: InputEvent) -> PlayState:
	return null

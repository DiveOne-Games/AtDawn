class_name PlayState extends Node


@export var animation: String
@export var move_state : PlayState
@export var combat_state : CombatState
@export var character: CharacterBody2D
var animator: AnimationPlayer

var is_combat := false
var is_moving := false


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

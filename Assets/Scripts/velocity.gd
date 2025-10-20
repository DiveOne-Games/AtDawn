extends Node

signal velocity_changed(change: Vector2)

@export var character: CharacterBody2D
var velocity : Vector2 :
	set(val): 
		velocity = val
		velocity_changed.emit(val)


func _ready():
	velocity = character.velocity


func _process(_delta: float) -> void:
	if character.is_dead:
		return
	if not velocity == character.velocity:
		velocity = character.velocity

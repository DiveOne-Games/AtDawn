class_name IMovable extends Node
## Interface for input and motion control. 

@export var character : CharacterBody2D


func get_direction() -> Vector2:
	return Vector2.ZERO


func get_velocity() -> Vector2:
	return Vector2.ZERO

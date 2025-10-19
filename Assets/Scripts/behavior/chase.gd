class_name ChaseBehavior extends Behavior


var direction: Vector2
var target: CharacterBody2D 		## Object or unit to follow.
var max_distance: float = 10 	## Max distance from [member origin] unit will follow before returning home.

@export_category("Behavior Transitions")
@export var idle: Behavior


func start():
	super()


func end():
	direction = character.origin


func physics_update(_delta: float):
	if target and target.global_position.length() > max_distance:
		direction = target.global_position - character.global_position
	else:
		return idle
	character.velocity = direction * character.speed
	return null

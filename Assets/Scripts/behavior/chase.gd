class_name ChaseBehavior extends Behavior


var direction: Vector2
var target: CharacterBody2D 		## Object or unit to follow.
var max_distance: float = 10 	## Max distance from [member origin] unit will follow before returning home.

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var attack: Behavior


func start(old_state: Behavior = null):
	super(old_state)


func end():
	super()


func physics_update(_delta: float):
	# direction = character.position.direction_to(target.global_position)
	# direction = target.global_position - character.global_position
	if target:
		direction = character.position.direction_to(target.position)
		character.velocity = direction.normalized() * character.speed
	if direction.length() < max_distance:
		return attack
	return null

class_name ChaseBehavior extends Behavior


@export var chase_distance: float = 40 
var direction: Vector2
var target: CharacterBody2D 		## Object or unit to follow.

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var attack: Behavior


func start(old_state: Behavior = null):
	super(old_state)
	target = character.target


func end():
	super()


func physics_update(_delta: float):
	var distance : Vector2
	if target:
		direction = character.position.direction_to(target.position)
		character.velocity = direction.normalized() * character.stats.speed
		distance = target.global_position - character.global_position
	if distance.length() <= chase_distance:
		return attack
	return null

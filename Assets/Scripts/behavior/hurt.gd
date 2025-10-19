class_name HurtBehavior extends Behavior

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var death: Behavior


func start():
	super()


func end():
	super()


func physics_update(_delta: float) -> Behavior:
	if character.health <= 0:
		return death
	return null

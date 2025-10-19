class_name AttackBehavior extends Behavior

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var hurt: Behavior
@export var death: Behavior


func start():
	super()
	character.velocity = Vector2.ZERO
	

func end():
	super()


func physics_update(_delta: float) -> Behavior:
	if not character.target:
		return idle
	if character.health <= 0:
		return death
	return self

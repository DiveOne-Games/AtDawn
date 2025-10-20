class_name AttackBehavior extends Behavior

@export_category("Behavior Transitions")
@export var idle: Behavior


func start(old_state: Behavior = null):
	super(old_state)
	character.velocity = Vector2.ZERO


func end():
	super()


func physics_update(_delta: float) -> Behavior:
	if not character.target:
		return idle
	if character.health <= 0:
		return machine.death
	return self

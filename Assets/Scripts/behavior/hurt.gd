class_name HurtBehavior extends Behavior

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var death: Behavior
@export var attack: Behavior

func start(old_state: Behavior = null):
	super(old_state)


func end():
	super()


func physics_update(_delta: float) -> Behavior:
	if character.target:
		return attack
	if character.health <= 0:
		return death
	return null

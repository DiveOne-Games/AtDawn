class_name IdleBehavior extends Behavior

@export var is_patrol : bool = false
@export_category("Behavior Transitions")
@export var attack: Behavior
@export var patrol: Behavior


func start(old_state: Behavior = null):
	super(old_state)


func end():
	super()


func physics_update(_delta: float) -> Behavior:
	if character.target:
		return attack
	if is_patrol:
		return patrol
	return null

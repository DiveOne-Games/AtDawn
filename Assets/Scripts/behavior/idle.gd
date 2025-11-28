class_name IdleBehavior extends Behavior

@export var is_patrol : bool = false
@export var is_hurt : bool = false
@export_category("Behavior Transitions")
@export var attack: Behavior
@export var patrol: Behavior
@export var chase: Behavior

func start(old_state: Behavior = null):
	super(old_state)


func end():
	super()
	is_hurt = false


func physics_update(_delta: float) -> Behavior:
	if is_hurt:
		return machine.hurt
	if character.target:
		return attack  # TODO: chase
	if is_patrol:
		return patrol
	return null


func get_health_update():
	is_hurt = true

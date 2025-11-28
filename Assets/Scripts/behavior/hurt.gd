class_name HurtBehavior extends Behavior

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var death: Behavior
@export var attack: Behavior
var stagger_delay : float = 1
var counter = 0

func start(old_state: Behavior = null):
	super(old_state)


func end():
	super()
	counter = 0


func physics_update(_delta: float) -> Behavior:
	if character.health <= 0:
		return death
	if counter >= stagger_delay:
		return idle
	counter += _delta
	return null

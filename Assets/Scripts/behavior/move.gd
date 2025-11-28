class_name MoveBehavior extends Behavior

var direction: Vector2
var max_distance: float = 10 	## Max distance from [member origin] unit will follow before returning home.

@export_category("Behavior Transitions")
@export var idle: Behavior
@export var attack: Behavior


func start(old_state: Behavior = null):
	super(old_state)


func end():
	super()


func physics_update(_delta: float):
	character.velocity = direction.normalized() * character.speed
	return null


func _unhandled_input(_event):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

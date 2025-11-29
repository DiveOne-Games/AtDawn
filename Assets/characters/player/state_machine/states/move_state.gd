class_name MoveState extends PlayState

@export var idle_state : PlayState

var direction: Vector2
var speed: float


func start():
	super()
	speed = character.speed


func end():
	super()


func input(_event: InputEvent) -> PlayState:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		return move_state
	return idle_state

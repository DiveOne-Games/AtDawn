class_name MoveState extends PlayState
## Any locomotive or animation state that displays motion. That includes idle
## states.

var direction: Vector2
var speed: float


func start():
	super()
	speed = character.speed


func input(_event: InputEvent) -> PlayState:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return null

class_name MoveState extends PlayState

var direction: Vector2
var speed: float


func start():
	super()
	speed = character.speed


func end():
	super()

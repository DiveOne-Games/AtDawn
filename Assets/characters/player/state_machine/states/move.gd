class_name MoveState extends PlayState

var direction: Vector2
var max_distance: float = 10 	## Max distance from origin unit will follow before returning home.
var speed: float


func start():
	super()
	speed = character.speed


func end():
	super()


func physics_process(_delta: float):
	character.velocity = direction.normalized() * speed
	#return null


func input(_event):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

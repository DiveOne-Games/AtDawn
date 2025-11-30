class_name RunState extends MoveState

@export var speed_scale : float = 1.5	## Increase movement speed by scaling current speed.


func physics_process(_delta: float):
	character.velocity = direction.normalized() * (speed *speed_scale)
	if character.velocity == Vector2.ZERO:
		return move_state
	return null


func input(_event):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

class_name IdleState extends PlayState

@export var move_state : MoveState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


func process(_delta: float) -> PlayState:
	if not character.velocity == Vector2.ZERO:
		return next_state
	return null


func input(event: InputEvent) -> PlayState:
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left") or \
	event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		return move_state
	return null

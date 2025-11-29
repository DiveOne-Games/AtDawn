class_name IdleState extends PlayState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


func process(_delta: float) -> PlayState:
	if not character.velocity == Vector2.ZERO:
		return move_state
	return null


func input(_event: InputEvent) -> PlayState:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.length():
		return move_state
	if _event.is_pressed():
		return combat_state

	return null

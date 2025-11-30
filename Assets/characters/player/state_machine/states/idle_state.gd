class_name IdleState extends MoveState


func input(event: InputEvent) -> PlayState:
	super(event)
	if direction.length():
		return move_state
	if event.is_pressed():
		return combat_state

	return null

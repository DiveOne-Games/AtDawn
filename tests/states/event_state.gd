class_name EventState extends PlayState

signal transition(next_state: String)


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


func process(_delta: float):
	if not character.velocity == Vector2.ZERO:
		transition.emit('Run')
	else:
		transition.emit('Idle')


func physics_process(_delta: float):
	pass


func input(_event: InputEvent):
	pass

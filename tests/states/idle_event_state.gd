class_name IdleEventState extends EventState

@export var next_state : EventState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


func process(_delta: float) -> PlayState:
	#if character.velocity == Vector2.ZERO:
		#transition.emit('Idle')
	#else:
		#transition.emit('Run')
	return null


func physics_process(_delta: float) -> PlayState:
	return null


func input(_event: InputEvent) -> PlayState:
	return null

class_name IdleState extends PlayState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


#func process(_delta: float) -> PlayState:
	#return null
#
#
#func physics_process(_delta: float) -> PlayState:
	#return null
#
#
#func input(_event: InputEvent) -> PlayState:
	#return null

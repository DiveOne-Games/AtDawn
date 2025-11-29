class_name ComboAttackState extends CombatState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished

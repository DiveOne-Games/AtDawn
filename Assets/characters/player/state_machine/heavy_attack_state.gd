class_name HeavyAttackState extends CombatState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished

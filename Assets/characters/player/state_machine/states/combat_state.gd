class_name CombatState extends PlayState

@export var light_attack : CombatState
@export var medium_attack : CombatState
@export var heavy_attack : CombatState
@export var combo : CombatState


func start():
	animator.play(animation)


func end():
	await animator.animation_finished


func process(_delta: float) -> PlayState:
	return null


func physics_process(_delta: float) -> PlayState:
	return null


func input(event: InputEvent) -> PlayState:
	if event.is_action("attack_slash"):
		return medium_attack
	elif event.is_action("attack_stab"):
		return light_attack
	elif event.is_action("attack_back_slash"):
		return heavy_attack
	elif event.is_action("attack_combo"):
		return combo
	return move_state

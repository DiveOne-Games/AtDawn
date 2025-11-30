class_name CombatState extends PlayState

@export var light_attack : CombatState
@export var medium_attack : CombatState
@export var heavy_attack : CombatState
@export var combo : CombatState
@export var attacks : Dictionary[String, StringName] = {
	'light': 'attack_stab', 'medium': 'attack_slash', 
	'heavy': 'attack_back_slash', 'combo': 'attack_combo'}

var current_state : PlayState


func end():
	super()
	current_state = null


func process(_delta: float) -> PlayState:
	if not animator.is_playing():
		return move_state
	return null


func input(event: InputEvent) -> PlayState:
	if event.is_action(attacks.get('medium')):
		return medium_attack
	elif event.is_action(attacks.get('light')):
		return light_attack
	elif event.is_action(attacks.get('heavy')):
		return heavy_attack
	elif event.is_action(attacks.get('combo')):
		return combo
	return move_state

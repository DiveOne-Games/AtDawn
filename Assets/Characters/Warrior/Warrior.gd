extends PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	anim_tree.active = false


func _physics_process(_delta):
	change_face()

	if is_dead:
		if is_disabled:
			return
		animation_player.play(DEATH)
		disable_character()
		return

	if is_moving():
		is_running = true
		animation_player.play(RUN)
	elif is_attacking and current_state:
		animation_player.play(current_state)
	else:
		is_running = false
		is_attacking = false
		is_combo = false
		current_state = null
		animation_player.play(IDLE)

	if is_attacking or is_combo:
		if current_state:
			await sync_animation(current_state)
			is_attacking = false 
			is_combo = false
			current_state = null
	if is_hurt:
		animation_player.play(HURT)
		reaction_timer(0.5)
	
	velocity = motion.normalized() * speed(_delta)
	move_and_slide()


func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		is_attacking =true
		if event.is_action(ATTACK_SLASH):
			current_state = ATTACK_SLASH
		if event.is_action(ATTACK_BACK_SLASH):
			current_state = ATTACK_BACK_SLASH
		if event.is_action(ATTACK_STAB):
			current_state = ATTACK_STAB
		if event.is_action(ATTACK_COMBO):
			is_combo = true
			current_state = ATTACK_COMBO
	

func sync_animation(anim):
	if is_running:
		animation_player.stop()
	else:
		await animation_player.animation_finished
	animation_player.play(anim)
	
	

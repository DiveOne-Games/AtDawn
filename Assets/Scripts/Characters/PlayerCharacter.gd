class_name PlayerCharacter
extends BaseCharacter

@export var attack_delay := 1.0
@export var gold : int = 5
var inventory : Array = []

@export_category('Camera Settings')
@export_range(0.5, 5, 0.25) var camera_zoom: float = 1
var zoom_in := false 
var zoom_out := false

const ATTACK_SLASH = 'attack_slash'
const ATTACK_BACK_SLASH = 'attack_back_slash'
const ATTACK_COMBO = 'attack_combo'
const ATTACK_STAB = 'attack_stab'
const ATTACKS = [ATTACK_BACK_SLASH, ATTACK_STAB, ATTACK_COMBO, ATTACK_SLASH]
const INTERACTION = 'interact'
const CAMERA_ZOOM = 'camera_in'
const CAMERA_UNZOOM = 'camera_out'

var current_state = null
var animation_player: AnimationPlayer
var camera: Camera2D
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")


func _ready():
	foot_shape = get_node('CollisionShape2D')
	hitbox = get_node('HitBox')
	sprite = get_node('Sprite2D')
	screen_size = get_viewport_rect().size 
	animation_player = get_node('AnimationPlayer')
	camera = get_node('Camera2D')
	motion = Vector2.ZERO

	anim_tree.active = true


func _process(delta):
	super(delta)
	motion = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	camera.zoom = Vector2(camera_zoom, camera_zoom)
	if zoom_in:
		camera_zoom += 0.1
		await reaction_timer(0.25)
		zoom_in = false
	if zoom_out:
		camera_zoom -= 0.1
		await reaction_timer(0.25)
		zoom_out = false


func _physics_process(_delta):
	change_face()

	if is_dead:
		if is_disabled:
			return
		disable_character()
		return

	if is_moving():
		is_running = true
		is_idle = false
		state_machine.travel(RUN)
	elif is_attacking and current_state:
		state_machine.travel(current_state)
	else:
		is_running = false 
		is_idle = true
		state_machine.travel(IDLE)

	if is_attacking or is_combo:
		attack_timer(0.5)
	if is_hurt:
		state_machine.travel(HURT)
		reaction_timer(0.5)

	velocity = motion.normalized() * speed(_delta)
	move_and_slide()


func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		is_idle = false
		is_attacking = true
		if event.is_action(ATTACK_BACK_SLASH):
			current_state = ATTACK_BACK_SLASH
		if event.is_action(ATTACK_SLASH):
			current_state = ATTACK_SLASH
		if event.is_action(ATTACK_STAB):
			current_state = ATTACK_STAB
		if event.is_action(ATTACK_COMBO):
			is_combo = true
			current_state = ATTACK_COMBO
		if event.is_action_pressed(INTERACTION):
			print('TODO: Interaction isnt implemented.')
		if event.is_action(CAMERA_ZOOM):
			zoom_in = true 
		if event.is_action_pressed(CAMERA_UNZOOM):
			zoom_out = true


func change_face():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false


func speed(delta: float = 1) -> float:
	return player_speed * speed_scale * delta


func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_combo', is_combo)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


func is_moving():
	return not velocity == Vector2.ZERO


func attack_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_attacking = false 
	is_combo = false
	current_state = null


func reaction_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_hurt = false 


func collect_item(item: CollectibleItem):
	if item.item_type == item.ItemType.Gold:
		gold += item.value
		return
	inventory.append(item.item)


func disable_character():
	super()
	foot_shape.disabled = true
	hitbox.disabled = true
	

func scale_animation(value: float):
	animation_player.speed_scale = value
	

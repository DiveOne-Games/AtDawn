class_name PlayerCharacter
extends BaseCharacter

@export var attack_delay := 1.0
@export var gold : int = 5
var inventory : Array = []

const ATTACK_SLASH = 'attack_slash'
const ATTACK_BACK_SLASH = 'attack_back_slash'
const ATTACK_COMBO = 'attack_combo'
const ATTACK_STAB = 'attack_stab'
const ATTACKS = [ATTACK_BACK_SLASH, ATTACK_STAB, ATTACK_COMBO, ATTACK_SLASH]

var current_state = null

var animation_player: AnimationPlayer
var camera: Camera2D
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
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


func _physics_process(_delta):
	change_face()

	if is_dead:
		state_machine.travel(DEATH)
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
		if event.is_action(ATTACK_SLASH):
			is_attacking = true
			current_state = ATTACK_SLASH
		elif event.is_action(ATTACK_COMBO):
			is_combo = true
			current_state = ATTACK_COMBO
	

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
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


func is_moving():
	return not velocity == Vector2.ZERO


func attack_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_attacking = false 
	is_combo = false


func reaction_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_hurt = false 


func collect_item(item: CollectibleItem):
	if item.item_type == item.ItemType.Gold:
		gold += item.value
	else:
		inventory.append(item)


func scale_animation(value: float):
	animation_player.speed_scale = value


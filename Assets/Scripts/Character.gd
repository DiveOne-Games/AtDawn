class_name CharacterController
extends CharacterBody2D


@export_group('Player Settings')
@export var player_speed := 30

const ATTACK_SLASH = 'attack_slash'
const ATTACK_BACK_SLASH = 'attack_back_slash'
const ATTACK_COMBO = 'attack_combo'
const ATTACK_STAB = 'attack_stab'
const RUN = 'run'
const HURT = 'hurt' 
const DEATH = 'death'
const IDLE = 'idle'

var sprite: Sprite2D
var screen_size: Vector2 
var animation_player: AnimationPlayer
var motion: Vector2
var speed_scale := 1000
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

var is_idle := true
var is_attacking := false 
var is_running := false 
var is_hurt := false 
var is_dead := false 

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node('Sprite2D');
	screen_size = get_viewport_rect().size 
	animation_player = get_node('AnimationPlayer')
	motion = Vector2.ZERO
	# anim_tree.active = true

func _process(_delta):
	motion = Vector2(
		Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),
		Input.get_action_strength('move_down') - Input.get_action_strength('move_up')
	)


func _physics_process(_delta):
	change_face()

	if motion.x != 0 or motion.y !=0:
		is_running = true
		is_idle = false
		animation_player.play(RUN)
		# state_machine.travel(RUN)
	else:
		animation_player.play(IDLE)


	velocity = motion.normalized() * speed(_delta)
	move_and_slide()


func _input(event):
	if event.is_action('attack_slash'):
		is_attacking = true
		is_idle = false
		# animation_player.play(ATTACK_SLASH)
	else:
		is_idle = true
	# if event is InputEventKey and event.keycode == KEY_SPACE:
	# 	animation_player.play(ATTACK_STAB)
	

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
	# anim_tree['parameters/conditions/is_hurt'] = is_hurt
	# anim_tree['parameters/conditions/is_dead'] = is_dead


func is_moving():
	return not velocity == Vector2.ZERO

func is_slashing():
	return is_attacking 

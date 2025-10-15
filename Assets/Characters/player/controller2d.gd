extends CharacterBody2D
class_name Controller2D
## Controls the state of character movement.

const RUN = 'run'
const HURT = 'hurt' 
const DEATH = 'death'
const IDLE = 'idle'
const ATTACK = 'attack'
const WALK = 'walk'

enum Action { LEFT, RIGHT, UP, DOWN, IDLE, RUN, WALK, ATTACK, CHASE, HURT, DEAD }

#@export var player: PlayerCharacter
var is_spawning := true
var is_chasing := false
var is_idle := true
var idle_left := false 
var idle_right := true
var is_attacking := false 
var is_combo := false
var is_running := false 
var is_walking := false
var is_hurt := false 
var is_dead := false 
var is_disabled := false
var state : Action = Action.IDLE

var screen_size: Vector2 
var speed_scale := 1000
var motion : Vector2
var _speed: float

@onready var anim_tree : AnimationTree = %AnimationTree


func _process(_delta):
	motion = Vector2.ZERO


func _physics_process(delta):
	update_animations()

	if is_dead:
		if is_disabled:
			return
		disable_character()
		return
	if is_moving():
		is_running = true
		is_idle = false
	else:
		is_idle = true
		is_running = false
		is_walking = false

	if is_hurt:
		await reaction_timer(0.55 + delta)
	velocity = motion.normalized() * speed(delta)
	move_and_slide()


func update_state():
	match state:
		Action.LEFT:
			pass
		Action.RIGHT:
			pass
		Action.ATTACK:
			pass
		Action.CHASE:
			pass
		Action.RUN:
			pass
		Action.WALK:
			pass
		Action.HURT:
			pass
		Action.DEAD:
			pass


func speed(delta: float = 1) -> float:
	return _speed * speed_scale * delta


func is_moving():
	return not velocity == Vector2.ZERO


func reaction_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_hurt = false 


# ANIMATION and VISUAL -----
func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


func disable_character():
	pass

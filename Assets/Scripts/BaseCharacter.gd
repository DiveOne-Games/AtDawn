class_name BaseCharacter
extends CharacterBody2D


# Public Members
@export_group('Character Settings')
@export var player_speed := 30
@export var max_health := 100
@export var health: int

var sprite: Sprite2D
var screen_size: Vector2 
var speed_scale := 1000
var motion : Vector2

var is_idle := true
var is_attacking := false 
var is_combo := false
var is_running := false 
var is_hurt := false 
var is_dead := false 
var is_disabled := false

var foot_shape : CollisionShape2D
var hitbox : HitBox

# Constants
const RUN = 'run'
const HURT = 'hurt' 
const DEATH = 'death'
const IDLE = 'idle'
const ATTACK = 'attack'
const WALK = 'walk'


# Enums
# Functions: private > public > static
func _ready():
	sprite = get_node('Sprite2D');
	screen_size = get_viewport_rect().size 

func change_face():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

func speed(delta: float = 1) -> float:
	return player_speed * speed_scale * delta

func update_animations():
	pass
	# anim_tree.set('parameters/conditions/is_running', is_moving())
	# anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	# anim_tree.set('parameters/conditions/is_idle', is_idle)
	# anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	# anim_tree.set('parameters/conditions/is_dead', is_dead)


func is_moving():
	return not velocity == Vector2.ZERO

func attack_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_attacking = false 
	is_combo = false


func reaction_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_hurt = false 


func disable_character():
	is_disabled = true


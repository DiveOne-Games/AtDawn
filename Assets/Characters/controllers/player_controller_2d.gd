class_name PlayerController2D
extends CharacterBody2D
"""
UNDER TEST.
"""
signal update_health(value: int, max: int)
signal update_kill_score(value: int)

const RUN = 'run'
const HURT = 'hurt' 
const DEATH = 'death'
const IDLE = 'idle'
const ATTACK = 'attack'
const WALK = 'walk'

enum Movement { LEFT, RIGHT, UP, DOWN, IDLE, RUN, WALK }

@export var player_speed := 30
@export var health: int
@export var max_health := 100
@export var score_value := 100
@export var unit_type : GameTypes.UnitType
@export var unit_group : GameTypes.Group = GameTypes.Group.Enemies
@export_range(20, 150, 5) var aggro_radius : float

@export_category('Patrol Settings')
@export var patrol_origin : Vector2				## Starting position or spawn point.
@export var patrol_destination : Node2D
@export var patrol_distance: Vector2				## The farthest distance unit can patrol away from origin.
@export var patrol_paths: Array[Marker2D] 
@export var can_patrol := false
@export var patrol_active := false
@export var patrol_point_margin: float = 0.5 
@export var rest_duration := 6					## Seconds to wait at destination before resuming patrol.

@onready var navigation_agent: NavigationAgent2D = get_node('Navigator/NavigationAgent2D')
@onready var sfx_player: CharacterSFXPlayer = $AudioStreamPlayer2D
@onready var anim_tree := %AnimationTree
@onready var state_machine = %AnimationTree.get("parameters/playback")
@onready var aggro_area := $AttackArea/CollisionShape2D
@onready var navigator := $Navigator

var current_destination: Vector2
var character_disabled := false
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
var state : Movement = Movement.IDLE

var screen_size: Vector2 
var speed_scale := 1000
var motion : Vector2
var foot_shape : CollisionShape2D
var hitbox : HitBox
var target : PlayerCharacter
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	foot_shape = get_node('./CollisionShape2D')
	hitbox = get_node('HitBox')
	motion = Vector2()
	aggro_area.shape.radius = aggro_radius
	
	add_to_group(GameTypes.get_game_group(unit_group))
	state_machine.travel('skeleton_spawn')

	if not patrol_origin:
		patrol_origin = position
	
	call_deferred('nav_sync')


func _process(_delta):
	motion = Vector2.ZERO


func _physics_process(delta):
	change_face()
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
	
	if patrol_active:
		if navigation_agent.is_navigation_finished():
			is_idle = true
			is_running = false
			get_next_position()
		else:
			patrol()

	velocity = motion.normalized() * speed(delta)

	move_and_slide()


# PATROLS -----
func nav_sync():
	await get_tree().physics_frame
	if not patrol_destination:
		current_destination = patrol_origin + patrol_distance
	else:
		current_destination = patrol_destination.position
	set_movement_target(current_destination)
	
	
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


func patrol():
	# https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html#methods
	motion = to_local(navigation_agent.get_next_path_position())


func patrol_to(destination: Vector2):
	motion = to_local(destination)


func get_next_position():
	# FIXME: Almost there -- stutters when resuming patrol, flipping back and forth in place.
	await get_tree().create_timer(rest_duration).timeout
	if abs(navigation_agent.target_position - patrol_origin).length() <= patrol_point_margin:
		navigation_agent.target_position = current_destination
	else:
		navigation_agent.target_position = patrol_origin


func update_state():
	match state:
		Movement.LEFT:
			sprite.flip_h = true
		Movement.RIGHT:
			sprite.flip_h = false


func change_face():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false


func speed(delta: float = 1) -> float:
	return player_speed * speed_scale * delta


func is_moving():
	return not velocity == Vector2.ZERO


func attack_timer(timeout: float):
	await get_tree().create_timer(timeout).timeout
	is_attacking = false 
	is_combo = false


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
	foot_shape.disabled = true
	hitbox.disabled = true


# EVENTS -----

func attack(_new_target: PlayerCharacter):
	is_attacking = true
	sprite.flip_h = !_new_target.sprite.flip_h


func chase(_new_target: PlayerCharacter):
	# TODO: use navigation to walk into player attack zone
	sprite.flip_h = !_new_target.sprite.flip_h


func _on_aggro_area_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug("Entered shape: ", area)
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			chase(area.character)


func _on_aggro_area_body_exited(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			is_chasing = false


func _on_attack_area_body_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug("Entered area: ", area)
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			attack(area.character)


func _on_attack_area_body_exited(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug("Exited area: ", area)
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			is_attacking = false

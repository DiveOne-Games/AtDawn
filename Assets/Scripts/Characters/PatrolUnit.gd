class_name PatrolUnit
extends BaseCharacter
"""
A patrol unit is for non-player characters who move around from point to point.
Don't forget to call `super()` for functions which add to its behavior!
"""
const ANIM_SPAWN = 'skeleton/spawn'

@export var score_value := 100
@export var unit_type : GameTypes.UnitType
@export var unit_group : GameTypes.Group = GameTypes.Group.Enemies

@export_category('Patrol')
@export var patrol_origin : Node2D
@export var patrol_paths: Array 
@export var patrol_active := true
@export var patrol_point_margin: float = 1.5
@export_range(20, 150, 5) var aggro_radius : float

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = get_node('Navigation/NavigationAgent2D')
@onready var sfx_player: CharacterSFXPlayer = $AudioStreamPlayer2D
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")
@onready var aggro_area := $AttackArea/CollisionShape2D

var character_disabled := false
var is_spawning := true
var is_chasing := false

# Navigation
var current_destination: Node2D


func _ready():
	foot_shape = get_node('./CollisionShape2D')
	hitbox = get_node('HitBox')
	sprite = get_node('Sprite2D')
	motion = Vector2()
	aggro_area.shape.radius = aggro_radius
	
	add_to_group(GameTypes.get_game_group(unit_group))
	state_machine.travel('skeleton_spawn')
	anim_tree.active = true

	if not patrol_origin:
		patrol_active = false
#	
	if patrol_active:
		current_destination = patrol_origin
		call_deferred('actor_setup')


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

	if is_hurt:
		await reaction_timer(0.55 + delta)
	
	if patrol_active:
		if navigation_agent.is_navigation_finished():
			is_idle = true
			is_running = false
		else:
			# TODO: how to add more more nodes to patrol to?
			patrol()

	velocity = motion.normalized() * speed(delta)
	move_and_slide()


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(current_destination.position)


func patrol():
	if navigation_agent.is_target_reached():
		get_next_position()
	motion = to_local(navigation_agent.get_next_path_position())


func patrol_to(destination):
	print_debug('Patrol to ', destination)
	motion = to_local(destination)


func get_next_position():
#	if current_destination == patrol_destination:
#		navigation_agent.target_position = patrol_destination.position
#		current_destination = patrol_destination
#	else:
	navigation_agent.target_position = patrol_origin.position
	current_destination = patrol_origin


func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)
	anim_tree.set('parameters/conditions/is_spawning', is_spawning)


func attack(target: PlayerCharacter):
	is_attacking = true
	sprite.flip_h = !target.sprite.flip_h
	

func chase(target: PlayerCharacter):
	# TODO: use navigation to walk into player attack zone
	sprite.flip_h = !target.sprite.flip_h
	

func _on_aggro_area_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			chase(area.character)


func _on_aggro_area_body_exited(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			is_chasing = false


func _on_attack_area_body_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			attack(area.character)


func _on_attack_area_body_exited(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		if is_instance_of(area.character, PlayerCharacter):
			is_attacking = false


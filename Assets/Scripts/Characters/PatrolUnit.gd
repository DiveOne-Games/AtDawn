class_name PatrolUnit
extends BaseCharacter
"""
A patrol unit is for non-player characters who move around from point to point.
Don't forget to call `super()` for functions which add to its behavior!
"""


@export_category('Patrol')
@export var patrol_origin : Node2D
@export var patrol_paths: Array 
@export var patrol_active := true
@export var patrol_point_margin: float = 1.5 

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = get_node('Navigation/NavigationAgent2D')
@onready var sfx_player: CharacterSFXPlayer = $AudioStreamPlayer2D
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

var character_disabled := false

# Navigation
var current_destination: Node2D


func _ready():
	foot_shape = get_node('./CollisionShape2D')
	hitbox = get_node('HitBox')
	sprite = get_node('Sprite2D')
	motion = Vector2()
	anim_tree.active = true

	if not patrol_origin:
		patrol_origin.position = position
	current_destination = patrol_origin
#	
	if patrol_active:
		call_deferred('actor_setup')


func _process(_delta):
	motion = Vector2.ZERO

func _physics_process(delta):
	change_face()
	update_animations()

	if is_dead:
		if character_disabled:
			return
		# await reaction_timer(1)
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


func disable_character():
	super()
	foot_shape.disabled = true
	hitbox.disabled = true


func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


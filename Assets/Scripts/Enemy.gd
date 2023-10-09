class_name EnemyCharacter
extends BaseCharacter


@export var patrol_paths: Node2D
@export var can_patrol := false
@export var patrol_origin : Node2D
@export var patrol_destination : Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sfx_player: CharacterSFXPlayer = $AudioStreamPlayer2D
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

var character_disabled := false
var arrived := false
var travelling: = false

func _ready():
	foot_shape = get_node('./CollisionShape2D')
	hitbox = get_node('HitBox')
	sprite = get_node('Sprite2D')
	motion = Vector2()
	anim_tree.active = true
	
	# navigation_agent.path_desired_distance = 2.0
	# navigation_agent.target_desired_distance = 2.0

	call_deferred('actor_setup')


func _process(_delta):
	motion = Vector2.ZERO

func _physics_process(delta):
	change_face()
	update_animations()

	# TODO: This nesting exists because of desire to keep corpse onscreen. Can always delete it and flatten this.
	if is_dead:
		if character_disabled:
			return
		# await reaction_timer(1)
		disable_character()
		return
	elif not is_dead:
		if is_moving():
			is_running = true
			is_idle = false

		if is_hurt:
			await reaction_timer(0.55 + delta)
		
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
	navigation_agent.path_desired_distance = 2.0
	navigation_agent.target_desired_distance = 2.0
	await get_tree().physics_frame
	set_movement_target(patrol_destination.position)


func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


func patrol():
	if position == patrol_destination.position:
		navigation_agent.target_position = patrol_origin.position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	motion = next_path_position - global_position


func die():
	# FIXME: sfx still spamming no matter where configured. Not sure whats up.
	anim_player.play(DEATH)
	sfx_player.stream = sfx_player.hurt
	sfx_player.play()


func disable_character():
	super()
	foot_shape.disabled = true
	hitbox.disabled = true

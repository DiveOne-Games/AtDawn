class_name EnemyCharacter
extends BaseCharacter


@export var patrol_paths: Node2D
@export var can_patrol := false
@export var patrol_origin : Node2D
@export var patrol_destination : Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var movement_target_position: Vector2

func _ready():
	sprite = get_node('Sprite2D')
	motion = Vector2()
	movement_target_position = patrol_destination.position

	navigation_agent.path_desired_distance = 2.0
	navigation_agent.target_desired_distance = 2.0

	call_deferred('actor_setup')


func _process(_delta):
	motion = Vector2.ZERO

func _physics_process(delta):
	change_face()

	if is_dead:
		anim_player.play(DEATH)
		reaction_timer(1)
		# TODO: Death sfx, vfx and restart player from last checkpoint
		return

	if is_moving():
		is_running = true
		is_idle = false
		anim_player.play('skeleton/walk')
	elif is_attacking:
		anim_player.play('skeleton/attack')
	else:
		is_running = false 
		is_idle = true
		anim_player.play('skeleton/idle')

	# if navigation_agent.is_navigation_finished():
	# 	is_idle = true
	# 	is_running = false
	# else:
	# 	# TODO: Figure out how to setup a patrol; currently just walks to 1 spot.
	# 	patrol()
	
	if is_hurt:
		# TODO: Not playing the full animation. Swap to state machine instead of anim player?
		anim_player.play(HURT)
		reaction_timer(0.55)

	velocity = motion.normalized() * speed(delta)
	move_and_slide()

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target_position)


func patrol():
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	motion = next_path_position - global_position

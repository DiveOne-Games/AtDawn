extends BaseCharacter


@export_category('Patrol')
@export var patrol_origin : Node2D
@export var patrol_destination : Node2D
@export var patrol_paths: Array 
@export var can_patrol := false
@export var patrol_point_margin: float = 0.5 

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = get_node('Navigation/NavigationAgent2D')
@onready var sfx_player: CharacterSFXPlayer = $AudioStreamPlayer2D
@onready var anim_tree := $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

var character_disabled := false

# Navigation
var current_destination: Node2D
var current_patrol_path: PackedVector2Array
var current_path_point: Vector2
var patrol_nodes: Array[Node2D]
var default_2d_map_rid: RID 
var current_path_index: int = 0
var patrol_queue: Queue
var is_patrolling := false 


func _ready():
	foot_shape = get_node('./CollisionShape2D')
	hitbox = get_node('HitBox')
	sprite = get_node('Sprite2D')
	motion = Vector2()
	anim_tree.active = true

	if not patrol_origin:
		patrol_origin.position = position
	current_destination = patrol_destination
	
	default_2d_map_rid = get_world_2d().get_navigation_map()
	patrol_nodes = get_patrol_nodes()
	patrol_queue = Queue.new(patrol_nodes)
	
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
	
	if navigation_agent.is_navigation_finished():
		is_idle = true
		is_running = false
	else:
		# TODO: how to add more more nodes to patrol to?
		# patrol()
		get_patrol()

	velocity = motion.normalized() * speed(delta)
	move_and_slide()


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	

func actor_setup():
	await get_tree().physics_frame
	# set_movement_target(current_destination.position)


func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


func patrol():
	if navigation_agent.is_target_reached():
		get_next_position()
	motion = to_local(navigation_agent.get_next_path_position())


func get_next_position():
	if current_destination == patrol_destination:
		navigation_agent.target_position = patrol_destination.position
		current_destination = patrol_destination
	else:
		navigation_agent.target_position = patrol_origin.position
		current_destination = patrol_origin


func get_new_nav_path(destination: Vector2):
	await get_tree().create_timer(1).timeout
	current_patrol_path = NavigationServer2D.map_get_path(default_2d_map_rid, 
		position, 
		destination, 
		true)
	if not current_patrol_path.is_empty():
		current_path_index = 0
		current_path_point = current_patrol_path[0]


func get_patrol_nodes() -> Array[Node2D]:
	var path_nodes: Array[Node2D] = []
	for node_path in patrol_paths:
		var node: Node2D = get_node(node_path)
		path_nodes.append(node)
	return path_nodes

func get_patrol():
	if is_patrolling:
		print_debug('Patrolling ', current_destination)
		if global_position.distance_to(current_path_point) <= patrol_point_margin:
			current_path_index += 1
			# Make sure the path index doesn't exceed the size of the patrol; reset patrol if
			if current_path_index >= current_patrol_path.size():
				current_patrol_path = []
				current_path_index = 0
				current_path_point = global_transform.origin
				return
	else:
		# is_patrolling = true 
		await get_new_nav_path(patrol_queue.dequeue().position)	
		goto()
		return
	print_debug('Get patrol ...')
	current_path_point = current_patrol_path[current_path_index]
	motion = to_local(current_path_point)


func goto():
	is_patrolling = true
	if patrol_queue.is_empty():
		patrol_queue = Queue.new(patrol_nodes) 
	if global_position.distance_to(current_destination.position) <= patrol_point_margin:
		current_destination = patrol_queue.dequeue()
		get_new_nav_path(current_destination.position)
	print_debug('Start patrol on path ', current_patrol_path)


func disable_character():
	super()
	foot_shape.disabled = true
	hitbox.disabled = true


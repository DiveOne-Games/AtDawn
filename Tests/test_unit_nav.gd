extends BaseCharacter

@export var score_value := 0
@export var unit_type : GameTypes.UnitType
@export var unit_group : GameTypes.Group = GameTypes.Group.Enemies

@export_category('Patrol')
@export var patrol_origin : Node2D
@export var patrol_paths: Array = []
@export var patrol_active := false
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
var is_resting := false 

func _ready():
	foot_shape = get_node('./CollisionShape2D')
	hitbox = get_node('HitBox')
	sprite = get_node('Sprite2D')
	motion = Vector2()
	anim_tree.active = true

	default_2d_map_rid = get_world_2d().get_navigation_map()
	patrol_nodes = get_patrol_nodes()
	patrol_queue = Queue.new(patrol_nodes.duplicate())
	current_destination = patrol_origin
	
#	await sync_map()
	call_deferred('sync_map')
	

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
		if is_walking:
			player_speed = 10
			is_running = false
		if is_running:
			player_speed = 20
			is_walking = false
#		is_running = true
		is_idle = false
	else:
		is_idle = true
		is_running = false

	if is_hurt:
		await reaction_timer(0.55 + delta)
	
	if patrol_active:
		if current_patrol_path.is_empty():
			return
#			is_patrolling = false
		if patrol_queue.is_empty():
			reset_patrol_queue()
		if is_at_destination(current_destination.position):
			# TODO: Unit should stop when reaching destination
			get_next_node()
		patrol()

	velocity = motion.normalized() * speed(delta)
	move_and_slide()


func get_new_nav_path(destination: Vector2):
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


func patrol():
	"""Initializes patrol path and sets next path point."""
	if not is_patrolling:
		print_debug('Patrol start.')
		current_destination = patrol_queue.dequeue()
		get_new_nav_path(current_destination.position)
		is_patrolling = true
		is_walking = true
		return
	
	if is_at_destination(current_path_point):
		current_path_index += 1
		# Make sure the path index doesn't exceed the size of the patrol else reset patrol
		if current_path_index >= current_patrol_path.size():
			print_debug('Reset current path.')
			current_patrol_path = []
			current_path_index = 0
			current_path_point = global_transform.origin
			return
	
	current_path_point = current_patrol_path[current_path_index]
	motion = to_local(current_path_point)


func sync_map():
	await get_tree().create_timer(0.5).timeout
	get_new_nav_path(current_destination.position)
	navigation_agent.get_path()


func get_next_node():
	# TODO: Patrols never rest!
	await patrol_rest(3)
	if patrol_queue.is_empty():
		reset_patrol_queue()
	is_patrolling = false
#	is_resting = true


func reset_patrol_queue():
	patrol_queue = Queue.new(patrol_nodes.duplicate())


func update_animations():
	anim_tree.set('parameters/conditions/is_running', is_moving())
	anim_tree.set('parameters/conditions/is_attacking', is_attacking)
	anim_tree.set('parameters/conditions/is_idle', is_idle)
	anim_tree.set('parameters/conditions/is_hurt', is_hurt)
	anim_tree.set('parameters/conditions/is_dead', is_dead)


func disable_character():
	super()
	foot_shape.disabled = true
	hitbox.disabled = true


func patrol_rest(duration: float):
	print_debug('Patrol resting for ', duration)
	await get_tree().create_timer(duration).timeout
	is_resting = false


func is_at_destination(path_point: Vector2) -> bool:
	return global_position.distance_to(path_point) <= patrol_point_margin

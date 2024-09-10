extends Node2D


@export var actor: BaseCharacter

var navigation_agent: NavigationAgent2D
var default_2d_map_rid: RID
var patrol_area: Array
var destinations: Queue
var current_destination: Vector2

#
#func _ready() -> void:
	#default_2d_map_rid = get_world_2d().get_navigation_map()
	#if patrol_area:
		#destinations = Queue.new(patrol_area)
	#call_deferred("map_sync")
#
#
#func _physics_process(delta):
	#if navigation_agent.is_navigation_finished():
		#get_next_destination()
	#elif navigation_agent.is_target_reached():
		#get_next_destination()
	#else:
		#patrol()


func map_sync():
	await get_tree().physics_frame
	navigation_agent.target_position = current_destination


func patrol():
	print_debug('Patrolling...')
	# https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html#methods
	current_destination = to_local(navigation_agent.get_next_path_position())
	actor.motion = current_destination


func reset_patrol():
	destinations = Queue.new(patrol_area)


func get_next_destination():
	if destinations.is_empty():
		reset_patrol()
	navigation_agent.target_position = destinations.dequeue()

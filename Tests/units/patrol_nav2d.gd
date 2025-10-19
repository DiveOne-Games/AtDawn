class_name Patrol2D extends NavigationAgent2D

@export_category('Patrol Settings')
@export var patrol_origin : Vector2				## Starting position or spawn point.
@export var patrol_destination : Node2D
@export var patrol_distance: Vector2				## The farthest distance unit can patrol away from origin.
@export var patrol_paths: Array[Marker2D] 
@export var can_patrol := false
@export var patrol_active := false
@export var patrol_point_margin: float = 0.5 
@export var rest_duration := 6					## Seconds to wait at destination before resuming patrol.

var current_destination: Vector2
var current_target: Vector2

@onready var navigation_agent: NavigationAgent2D = get_node('Navigator/NavigationAgent2D')
@onready var navigator := $Navigator


func _physics_process(_delta: float) -> void:
	if patrol_active:
		if navigation_agent.is_navigation_finished():
			get_next_position()
		else:
			patrol()


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
	current_destination = navigation_agent.get_next_path_position()


func patrol_to(destination: Vector2):
	current_destination = destination


func get_next_position():
	await get_tree().create_timer(rest_duration).timeout
	if abs(navigation_agent.target_position - patrol_origin).length() <= patrol_point_margin:
		navigation_agent.target_position = current_destination
	else:
		navigation_agent.target_position = patrol_origin


func _on_react_zone_target_updated(new_target: PlayerCharacter):
	current_target = new_target.position

extends Node2D

signal register_new_unit(unit: Node2D)  # TODO: Best if BaseCharacter

@export var unit_scene : PackedScene
@export var unit_group := GameTypes.Group.Enemies
@export var score_value := 100
@export var spawn_count : int = 1
@export var spawn_interval : float = 1
@export var spawn_radius : int = 10
@export var wave_count : int = 1
@export var wave_interval : float = 30
@export var allow_patrol : bool = true
@export var initial_delay : float = 3
@export var is_active := true

@onready var spawn_timer : Timer = $Timer

var units : Array
var current_wave : int
var current_spawn : int
var is_wave_complete := false
var timer_started := false

func _ready():
	spawn_timer.wait_time = spawn_interval
	current_wave = wave_count
	current_spawn = spawn_count
	
	if initial_delay:
		await delay(initial_delay)


func _process(_delta):
	if is_active and not timer_started:
		spawn_timer.start()
		timer_started = true
	if not current_spawn:
		spawn_timer.stop()


func spawn():
	# TODO: Figure out if the NavRegion needs to be in scene or on the SpawnPoint.
	if current_spawn == 0:
		is_wave_complete = true
		return
	if current_spawn > 0:
		current_spawn -= 1
		var node = unit_scene.instantiate()
		node.add_to_group(GameTypes.get_game_group(unit_group))
		register_new_unit.emit(node)
		node.patrol_active = allow_patrol
		node.score_value = score_value
		add_child(node)
		node.position = to_local(get_random_position(position))


func get_next_wave():
	if current_wave > 0:
		current_wave -= 1
		current_spawn = spawn_count
		is_wave_complete = false
	elif current_wave == 0:
		is_active = false


func delay(value: float):
	await get_tree().create_timer(value).timeout
	spawn_timer.start()
	

func move(unit):
	unit.patrol_to(get_random_position(position))


func get_random_position(start: Vector2) -> Vector2:
	var x = randi_range(start.x - spawn_radius, start.x + spawn_radius)
	var y = randi_range(start.y - spawn_radius, start.y + spawn_radius)
	return Vector2(x, y)


func _on_timer_timeout():
	spawn()

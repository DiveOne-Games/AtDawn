extends Hazard2D


@export var projectile : PackedScene
@export var launch_interval : float = 2.5
@export var launch_speed : float
@export var air_time : float
@export var direction : Vector2
@export var auto_fire := false
@export var is_active := true
@export var use_launchpoint := false

@onready var launch_point : Marker2D = $LaunchPoint
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var launch_timer : Timer = $LaunchTimer

var attack_zone : Area2D
var attack_zone_empty := true


func _ready():
	attack_zone = $AttackZone
	add_to_group('traps')
	print_debug('Group set to ', get_groups())
	
	launch_timer.wait_time = launch_interval
	launch_timer.start()


func _process(_delta):
	launch_timer.wait_time = launch_interval


func _physics_process(_delta):
	if auto_fire or not attack_zone_empty:
		await launch_timer.timeout
		animation_player.play(ANIMATION_SHOOT)
		animation_player.queue(ANIMATION_LOAD)
	else:
		await animation_player.animation_finished
#	if not attack_zone_empty:
#		animation_player.play(ANIMATION_SHOOT)	


func shoot():
	var fireball := projectile.instantiate() as Projectile
	fireball.position = get_launcher_position()
	fireball.projectile_speed = launch_speed
	fireball.air_time = air_time
	add_child(fireball)
	fireball.travel()


func get_launcher_position():
	var pos : Vector2 = to_local(position)
	if use_launchpoint:
		pos = launch_point.position
	return pos


func _on_attack_zone_player_entered(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		attack_zone_empty = false
		animation_player.play(ANIMATION_SHOOT)


func _on_attack_zone_area_shape_exited(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		attack_zone_empty = true
		animation_player.play(ANIMATION_LOAD)


func _on_aggro_zone_area_shape_entered(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		animation_player.play(ANIMATION_ACTIVATE)
		animation_player.queue(ANIMATION_LOAD)


func _on_aggro_zone_area_shape_exited(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		animation_player.play_backwards(ANIMATION_ACTIVATE)


# Animation player is managing the shot timing, not needed.
#func _on_launch_timer_timeout():
#	if auto_fire:
#		shoot()

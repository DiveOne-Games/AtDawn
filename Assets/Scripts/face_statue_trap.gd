extends Hazard


@export var projectile : PackedScene
@export var launch_interval : float = 2.5
@export var launch_speed : float
@export var air_time : float
@export var direction : Vector2
@export var auto_fire := false
@export var is_active := true

@onready var launch_point : Marker2D = $LaunchPoint
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var attack_zone : Area2D
var attack_zone_empty = true

func _ready():
	attack_zone = $AttackZone


func _physics_process(delta):
	if auto_fire:
		animation_player.play("fire")
	else:
		await animation_player.animation_finished
	if not attack_zone_empty:
		animation_player.play('fire')


func shoot_fireball():
	var fireball := projectile.instantiate() as Projectile
	fireball.position = to_local(position)
	fireball.projectile_speed = launch_speed
	fireball.air_time = air_time
	add_child(fireball)
	fireball.travel()


func _on_attack_zone_player_entered(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		attack_zone_empty = false
		animation_player.play("fire")


func _on_attack_zone_area_shape_exited(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		attack_zone_empty = true
		animation_player.play("glow")


func _on_aggro_zone_area_shape_entered(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		animation_player.play('activate')
		animation_player.queue('glow')


func _on_aggro_zone_area_shape_exited(_area_rid:RID, area: Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		animation_player.play_backwards("activate")

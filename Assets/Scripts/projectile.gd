class_name Projectile
extends RigidBody2D


@export var damage : int
@export var air_time : float = 5 # how long before auto destroy
@export var group_assignment : GameTypes.Group = GameTypes.Group.Projectiles
@export var direction : Vector2
@export var projectile_speed : int = 10
@export var projectile_type : GameTypes.ProjectileType = GameTypes.ProjectileType.Arrow

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $Timer
var group : String

var speed_scale : int = 100
var motion : Vector2 = Vector2.ZERO

var is_moving := false
var is_destroyed := false

const ANIMATION_FLY := 'fly'
const ANIMATION_DESTROY := 'destroy'
const ANIMATION_STICK := 'stick'


func _ready():
	group = GameTypes.get_game_group(group_assignment)
	add_to_group(group)
	print_debug('Group set to ', get_groups())
	timer.wait_time = air_time


func _physics_process(delta):
	if is_moving:
		motion = direction.normalized() * speed(delta)

	if is_destroyed:
		motion = Vector2.ZERO
		return
	
	move_and_collide(motion)


func destroy(sticky: bool = false):
	var anim = ANIMATION_DESTROY
	if sticky: 
		anim = ANIMATION_STICK
	sprite.play(anim)
	await sprite.animation_finished
	queue_free()


func speed(delta):
	return projectile_speed * speed_scale * delta


func travel():
	is_moving = true
	timer.start()


func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox) or area is HitBox2D:
		is_destroyed = true
		area.take_damage(damage)
		# Stick the arrow to the body
		if projectile_type == GameTypes.ProjectileType.Arrow:
			position = to_local(area.position)
			destroy(true)
			return
		destroy()


func _on_area_2d_body_entered(body):
	pass


func _on_timer_timeout():
	queue_free()

class_name Destructible extends Node2D
## Environmental objects that can be damaged or destroyed.

signal object_destroyed(points_scored: int)

enum DestructibleType { BARREL, CRATE, JAR }
enum DestructibleState { IDLE, DESTROYED, DISABLED }

@export var object_name : String
@export var points: int = 25
@export var type : DestructibleType = DestructibleType.BARREL

var state: DestructibleState = DestructibleState.IDLE
## The frame coords for each destructible object on the spritesheet.
var sprite_frame_map = {0: Vector2i(0,1), 1: Vector2i(0,3), 2: Vector2i(0,5)}
var anim_map = {0: 'Destructibles/barrel', 1: 'Destructibles/crate', 2: 'Destructibles/jar'}

@onready var sprite2d: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var area2d: Area2D = $Area2D


func _ready():
	sprite2d.frame_coords = sprite_frame_map[type]
	
	
func _physics_process(_delta: float):
	match state:
		DestructibleState.DESTROYED:
			object_destroyed.emit(points)
			state = DestructibleState.DISABLED
			anim_player.play(anim_map[type])


func _on_area_2d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area is WeaponZone:
		state = DestructibleState.DESTROYED
		area2d.set_deferred("monitoring", false)

class_name Hazard2D
extends StaticBody2D
# Environmental hazards are objects like traps and other dangers that can harm the player.

enum HazardState { OFF, ON, DISABLED }

const ANIMATION_ACTIVATE := 'activate'
const ANIMATION_LOAD := 'load'
const ANIMATION_SHOOT := 'shoot'

@export var trap: Hazard
@export var type: Hazard.HazardType = Hazard.HazardType.TRAP
@export var damage: int
var state: HazardState = HazardState.ON

@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready():
	call_deferred("prepare")


func _physics_process(_delta):
	if not anim_player.is_playing():
		anim_player.play("anim_spikes/active")


func prepare(new_trap: Resource = null):
	if new_trap:
		trap = new_trap
	type = trap.type
	damage = trap.damage
	if trap.is_animated:
		anim_sprite.sprite_frames = trap.sprite_frames
	else:
		sprite.texture = trap.texture


func _on_area_2d_area_shape_entered(_area_rid:RID, area, _area_shape_index:int, _local_shape_index:int):
	print_debug('Hazard area was entered by ', area)
	if is_instance_of(area, HitBox):
		area.take_damage(damage)

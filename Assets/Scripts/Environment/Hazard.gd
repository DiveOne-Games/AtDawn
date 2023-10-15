class_name Hazard
extends StaticBody2D
# Environmental hazards are objects like traps and other dangers that can harm the player.

@export var damage: int

const ANIMATION_ACTIVATE := 'activate'
const ANIMATION_LOAD := 'load'
const ANIMATION_SHOOT := 'shoot'


func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug('Hazard area was entered by ', area)
	if is_instance_of(area, HitBox):
		area.take_damage(damage)

extends Hazard


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug('SpikeTrap area was entered by ', area)
	if is_instance_of(area, HitBox):
		area.take_damage(damage)

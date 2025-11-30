extends Area2D

@export var character: CharacterBody2D


func take_damage(damage):
	character.update_health(damage)


func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, WeaponZone):
		print_debug('Struck for %d damage ' % area.damage)
		take_damage(-area.damage)
	if area is Equipable:
		take_damage(-area.damage())
	

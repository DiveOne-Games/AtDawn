class_name HitBox
extends Area2D

var character : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent()


func take_damage(damage):
	print_debug(character, ' HitBox damage received.')
	character.is_hurt = true
	character.health -= damage
	print_debug('Health ', character.health)
	if character.health <= 0:
		character.is_dead = true

func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug('Hitbox struck by ', area)
	if is_instance_of(area, WeaponZone):
		take_damage(area.damage)

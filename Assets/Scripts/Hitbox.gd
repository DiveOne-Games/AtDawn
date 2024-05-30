class_name HitBox
extends Area2D

@export var disabled := false 
var character : CharacterBody2D
var shape : CollisionShape2D


func _ready():
	character = get_parent()
	shape = get_node('CollisionShape2D')


func _process(_delta):
	shape.disabled = disabled
	

func take_damage(damage):
	character.is_hurt = true
	character.health -= damage
	if character.health <= 0:
		character.is_dead = true
		if not is_instance_of(character, PlayerCharacter):
			character.update_kill_score.emit(character.score_value)


func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, WeaponZone):
		print_debug('Hitbox struck by ', area)
		take_damage(area.damage)

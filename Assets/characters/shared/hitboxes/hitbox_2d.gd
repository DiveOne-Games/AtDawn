class_name HitBox2D extends Area2D

signal wounded(updated_health: int)

var character : CharacterBody2D
var shape : CollisionShape2D
@export var health: int 
@export var is_dead : bool = false


func _ready():
	character = get_parent()
	shape = get_node('CollisionShape2D')
	health = character.stats.health


func take_damage(damage):
	health -= damage
	if health <= 0:
		monitoring = false
		character.is_dead = true
	else:
		monitoring = true
	wounded.emit(health)


func _on_weapon_entered(_area_rid:RID, weapon: Area2D, _area_shape_index:int, _local_shape_index:int):
	if weapon is Weapon2D:
		take_damage(weapon.damage)

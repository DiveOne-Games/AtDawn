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
		set_deferred('monitoring', false)
		set_deferred('monitorable', false)
		character.is_dead = true
		is_dead = true
	else:
		set_deferred('monitoring', true)
		set_deferred('monitorable', true)
	wounded.emit(health)


func _on_weapon_entered(_area_rid:RID, weapon: Area2D, _area_shape_index:int, _local_shape_index:int):
	if weapon is Weapon2D or weapon is Equipable:
		take_damage(weapon.damage())

class_name HitBox
extends Area2D

var character : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent()

func take_damage(damage):
	print_debug('HitBox damage received.')
	character.is_hurt = true
	character.health -= damage
	print_debug('Health ', character.health)
	if character.health <= 0:
		character.is_dead = true

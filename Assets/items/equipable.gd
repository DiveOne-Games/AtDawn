class_name Equipable extends Area2D

@export var item : Weapon

var user : CharacterBody2D
@onready var shape : CollisionShape2D = $CollisionShape2D


func _ready():
	shape = get_node('CollisionShape2D')


func _physics_process(_delta):
	if user.facing_left and shape.position.x > 0:
		shape.position.x *= -1
	elif not user.facing_left and shape.position.x < 0:
		shape.position.x *= -1


func equip(_owner: CharacterBody2D):
	user = _owner


func damage():
	var hit_chance = randf_range(0, 1)
	var crit_chance = randf_range(0, 1)
	var dmg = randi_range(item.min_damage, item.max_damage)
	
	if hit_chance >= item.hit_chance:
		print_debug('Missed: ', hit_chance)
		return 0
	if crit_chance <= item.crit_chance:
		dmg *= item.crit_modifier
		print_debug('Crit! ', dmg)
		return dmg
	print_debug('Hit ', dmg)
	return dmg

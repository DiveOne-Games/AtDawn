class_name WeaponZone
extends Area2D

@export var damage := 5
@export var disable_shape := true

var character_sprite : Sprite2D
var shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var character = get_parent()
	character_sprite = character.get_node('Sprite2D')
	shape = get_node('WeaponShape2D')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	shape.disabled = disable_shape


func _physics_process(_delta):
	if character_sprite.flip_h and shape.position.x > 0:
		shape.position.x *= -1
	elif not character_sprite.flip_h and shape.position.x < 0:
		shape.position.x *= -1


# func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
# 	print_debug('Weapon has struck ', area)
# 	if is_instance_of(area, HitBox):
# 		area.take_damage(damage)


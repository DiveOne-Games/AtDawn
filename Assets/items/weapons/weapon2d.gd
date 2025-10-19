class_name Weapon2D extends Equipable

@export var disable_shape := true

@onready var vfx : AnimatedSprite2D = %AnimatedSprite2D
@onready var shape2d : CollisionShape2D = %CollisionShape2D


func _process(_delta):
	shape2d.disabled = disable_shape


func _physics_process(_delta):
	if user.facing_left and shape2d.position.x > 0:
		shape2d.position.x *= -1
	elif not user.facing_left and shape2d.position.x < 0:
		shape2d.position.x *= -1


func equip(_owner: CharacterBody2D):
	user = _owner


func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		print_debug("Weapon2D has hit ", area)
		vfx.play("smack")
		var dmg = randi_range(item.min_damage, item.max_damage)
		area.take_damage(dmg)

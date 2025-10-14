extends CharacterBody2D


var target : PlayerCharacter
@onready var sprite2d: Sprite2D = $Sprite2D


func _physics_process(_delta):
	if target:
		sprite2d.flip_h = true
	else:
		sprite2d.flip_h = false


func _on_aggro_area_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area is HitBox:
		print_debug("Player entered...")
		target = area.character

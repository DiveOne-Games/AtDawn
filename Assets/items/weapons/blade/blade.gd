class_name BladeWeapon extends Area2D

@export var stats: Weapon
@export var sfx: AudioStream
@onready var sprite2d: Sprite2D = %Sprite2D


func _ready():
	if not sprite2d.texture:
		sprite2d.texture = stats.texture
		sprite2d.texture_changed.emit()

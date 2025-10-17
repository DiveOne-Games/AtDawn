class_name BladeWeapon extends Area2D


@export var stats: Weapon
@export var texture: Texture2D
@export var sfx: AudioStream
@onready var sprite2d: Sprite2D = %Sprite2D


func _ready():
	if texture:
		sprite2d.texture = texture
		sprite2d.texture_changed.emit()

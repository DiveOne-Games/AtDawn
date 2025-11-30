class_name BladeWeapon extends Equipable

@export var stats: Weapon
@export var sfx: AudioStream
@onready var sprite2d: Sprite2D = %Sprite2D
@export var show_image := false


func _ready():
	if not sprite2d.texture:
		sprite2d.texture = stats.texture
		sprite2d.texture_changed.emit()


func _process(_delta):
	if show_image and not sprite2d.visible:
		sprite2d.show()

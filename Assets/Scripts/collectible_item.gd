class_name CollectibleItem
extends Node2D

@export var texture : Texture2D
@export var value : int
@export var item_type : ItemType
@export var sfx : AudioStreamMP3
@export var vfx : String


@onready var sprite : Sprite2D = $Sprite2D
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

enum ItemType { Gold, Collectible, Equipment }


func _ready():
	if not texture or not sfx or not value:
		push_warning('You have not configured this item. Loading defaults.')
		return
	elif texture:
		sprite.region_enabled = false
	sprite.texture = texture
	await sprite.texture_changed
	audio_player.stream = sfx
	value = randi_range(20, 40)


func play_sound(sound: AudioStream = sfx):
	audio_player.stream = sound
	audio_player.play()
	await get_tree().create_timer(0.25).timeout


func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug('Body ', area)
	if is_instance_of(area.character, PlayerCharacter):
		print_debug('Collected by ', area)
		sprite.visible = false
		await play_sound()
		area.character.collect_item(self)
		queue_free()

extends Node2D
class_name CollectibleItem
## Represents items in the game that the player can pick-up and use. It relies on
## the preset spritesheet!

enum ItemType { Gold, Collectible, Equipment }

@export var item : GameItem
@export var value : int
@export var item_type : GameItem.ItemType

@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	if not item.sprite or not item.sfx or not value:
		push_warning('You have not configured this item. Loading placeholders.')
		return
	sprite.region_enabled = item.use_region
	sprite.texture = item.sprite
	await sprite.texture_changed
	audio_player.stream = item.sfx
	value = randi_range(20, 40)


func prepare(new_item: GameItem):
	if not sprite:
		sprite = $Sprite2D
	item = new_item
	item_type = new_item.item_type
	sprite.frame_coords = new_item.frame_coords
	sprite.frame = new_item.frame


func play_sound(sound: AudioStream = item.sfx):
	audio_player.stream = sound
	audio_player.play()
	await get_tree().create_timer(0.25).timeout


func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug('Collecting ', item.item_name)
	if is_instance_of(area.character, PlayerCharacter):
		print_debug('Collected by ', area)
		sprite.visible = false
		await play_sound()
		area.character.collect_item(self)
		queue_free()

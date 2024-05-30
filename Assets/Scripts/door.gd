extends Node2D

@export var alt_texture : Texture2D

const DOOR_OPEN := 'open'
const DOOR_CLOSE := 'close'
const DOOR_ENTER := 'enter'

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
var original_texture : Texture2D
var is_present := false
var is_open := false


func _ready():
	original_texture = sprite.texture 
#	Events.player_interaction.connect(_on_player_present)


func open_door():
	anim_player.play(DOOR_OPEN)
	is_open = true
	await anim_player.animation_finished
	swap_texture()


func swap_texture():
	if alt_texture:
		sprite.texture = alt_texture
		await sprite.texture_changed
	anim_player.play(DOOR_ENTER)


func reset():
	sprite.texture = alt_texture
	await sprite.texture_changed


func _on_player_present(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	if is_instance_of(area, HitBox):
		if not is_open:
			open_door()


func _on_player_exit(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	is_present = false
	


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed('interact'):
		get_tree().change_scene_to_file('res://Assets/Levels/.tscn')

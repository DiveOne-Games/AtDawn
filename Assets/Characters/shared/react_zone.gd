class_name ReactZone extends Area2D
## The area around a character that detects other characters and/or objects.

signal target_updated(unit: PlayerCharacter)

enum ZoneType { CHASE, ATTACK, LOOK }
enum Reaction { IDLE, ACTIVE }
@export var type: ZoneType = ZoneType.LOOK

@export var character : CharacterBody2D
var state : Reaction = Reaction.IDLE
var target : PlayerCharacter :
	set(val):
		if val == target:
			return
		target = val
		target_updated.emit(target)


func _ready():
	if not character:
		character = get_parent()


func _physics_process(_delta: float) -> void:
	match state: 
		Reaction.ACTIVE:
			react()
			state = Reaction.IDLE


func react():
	match type:
		ZoneType.CHASE:
			character.chase(target)
		ZoneType.ATTACK:
			character.attack(target)
		ZoneType.LOOK:
			character.face(target)


func _on_react_zone_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int):
	if area is HitBox and area.character:
		target = area.character
		state = Reaction.ACTIVE


func _on_react_zone_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int):
	if area is HitBox and area.character:
		target = null
		state = Reaction.IDLE

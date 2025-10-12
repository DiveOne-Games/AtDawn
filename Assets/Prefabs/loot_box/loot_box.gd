extends StaticBody2D
class_name LootBox

enum LootBoxState { CLOSED, SELECTED, OPEN, EMPTY }

@export var item: GameItem

var loot: CollectibleItem
var state : LootBoxState = LootBoxState.CLOSED

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var collectible2d: PackedScene = preload("res://Assets/Prefabs/collectible.tscn")


func _ready():
	loot = collectible2d.instantiate()
	loot.prepare(item)


func _process(_delta):
	match state:
		LootBoxState.CLOSED:
			if not loot:
				loot = collectible2d.instantiate()
				loot.prepare(item)
		LootBoxState.OPEN:
			anim_player.play("open")
			spawn_loot()


func spawn_loot():
	state = LootBoxState.EMPTY
	add_child(loot)
	var tween = create_tween()
	tween.tween_property(loot, "position", loot.position + Vector2(0,50), 0.4)


func _on_area_shape_entered(_area_rid: RID, area, _area_shape_index: int, _local_shape_index: int) -> void:
	if not state == LootBoxState.EMPTY:
		if is_instance_of(area, PlayerCharacter):
			print_debug("Wooden chest opened.")
			state = LootBoxState.OPEN

extends Node2D

@export var player : PackedScene

@onready var title_layer : Control = $CanvasLayer
@onready var hud: CanvasLayer = $HUD
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_point: Marker2D = $PlayerSpawnPoint
@onready var thunder: Node2D = $PlayerSpawnPoint/Thunder
@onready var camera2d: Camera2D = $PlayerSpawnPoint/Camera2D
@onready var scene_mgr: SceneManager = $SceneManager


func _on_start_pressed():
	camera2d.global_position = spawn_point.global_position
	hud.visible = true
	title_layer.visible = false
	anim_player.play("scene_fade")
	await anim_player.animation_finished
	load_player()


func load_player():
	if not player:
		player = load("res://Assets/Characters/Warrior/Warrior.tscn")
	var character = player.instantiate()
	zoom_camera(Vector2(4,4))
	character.global_position = spawn_point.global_position
	thunder.get_node("AnimationPlayer").play("strike")
	add_child(character)


func zoom_camera(zoom: Vector2):
	var tween = create_tween()
	tween.tween_property(camera2d, "zoom", zoom, 2).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(0.5).timeout
	camera2d.enabled = false

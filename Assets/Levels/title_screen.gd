extends Node2D

@export var player : PackedScene

@onready var title_layer : Control = $CanvasLayer
@onready var hud: CanvasLayer = $HUD
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_point: Marker2D = $PlayerSpawnPoint

func _on_start_pressed():
	hud.visible = true
	title_layer.visible = false
	anim_player.play("title_fade")
	load_player()
	#get_tree().change_scene_to_file('res://Assets/Levels/crypts-hall-1.tscn')


func load_player():
	if not player:
		player = load("res://Assets/Characters/Warrior/Warrior.tscn")
	var character = player.instantiate()
	spawn_point.add_child(character)
	

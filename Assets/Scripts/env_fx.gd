class_name EnvironmentalFX extends Node

var object : Node2D
var camera : Camera2D

@onready var player: PlayerCharacter =  $Warrior

func _ready():
	object = get_parent()
	if object.camera:
		camera = object.camera


func _on_button_pressed():
	camera_shake()


func camera_shake():
	var tween = create_tween()
	tween.tween_property(camera, "zoom", camera.zoom *0.95, 0.10).set_trans(Tween.TRANS_ELASTIC)


func _on_critical_hit():
	camera_shake()

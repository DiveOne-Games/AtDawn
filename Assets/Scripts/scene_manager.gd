class_name SceneManager extends Node


@onready var anim_player : AnimationPlayer = %AnimationPlayer

var is_faded := false


func _ready():
	randomize()


func scene_transition(to: PackedScene, in_vfx = null, out_vfx = null):
	# play out effect here
	get_tree().change_scene_to_packed(to)
	# play in effect here

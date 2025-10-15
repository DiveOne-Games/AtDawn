extends Node2D

var object : Node2D

@onready var anim_player : AnimationPlayer =  $AnimationPlayer


func _ready():
	object = get_parent()


func _on_event(_points: int):
	anim_player.play("vfx/smoke_cloud")


func _on_destructible_object_destroyed(points_scored):
	anim_player.play("vfx/smoke_cloud")

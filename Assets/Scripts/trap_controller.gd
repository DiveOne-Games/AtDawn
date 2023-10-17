extends Node2D


@export var volume : float = 0

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer


func _process(_delta):
	audio.volume_db = volume


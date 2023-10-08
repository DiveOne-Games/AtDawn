class_name CharacterSFXPlayer
extends AudioStreamPlayer2D


@export var attack: AudioStreamMP3 = null
@export var hurt: AudioStreamMP3 = null
@export var death: AudioStreamMP3 = null
@export var footsteps: AudioStreamMP3 = null


# Called when the node enters the scene tree for the first time.
func _ready():
	attack.loop = false
	hurt.loop = false
	death.loop = false
	footsteps.loop = false



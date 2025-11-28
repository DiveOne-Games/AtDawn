class_name Controller2D extends CharacterBody2D

@export var animator : AnimationPlayer
@export var audio : AudioStreamPlayer2D
@export var state_machine : BehaviorMachine


func _ready():
	state_machine.init(self, animator)

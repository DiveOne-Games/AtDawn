class_name Controller2D extends CharacterBody2D

@export var animator : AnimationPlayer
@export var audio : AudioStreamPlayer2D
@export var state_machine : StateMachine
@export var speed : float = 400


func _ready():
	state_machine.init(self, animator)


func _process(delta):
	state_machine.process(delta)


func _physics_process(delta):
	state_machine.physics_process(delta)
	move_and_slide()


func _unhandled_input(event):
	state_machine.input(event)

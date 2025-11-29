class_name Controller2D extends CharacterBody2D

@export var animator : AnimationPlayer
@export var audio : AudioStreamPlayer2D
@export var state_machine : StateMachine
@export var speed : float = 400

@onready var avatar2d : Sprite2D = $Avatar2D
var facing_left := false


func _ready():
	state_machine.init(self, animator)


func _process(delta):
	state_machine.process(delta)


func _physics_process(delta):
	change_face(velocity.x)
	state_machine.physics_process(delta)
	move_and_slide()


func _unhandled_input(event):
	state_machine.input(event)


func change_face(vector: float):
	if vector < 0:
		facing_left = true
	elif vector > 0:
		facing_left = false
	avatar2d.flip_h = facing_left
	

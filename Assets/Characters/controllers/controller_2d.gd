class_name Controller2D extends CharacterBody2D

@export var stats : PlayerStats
@export var animator : AnimationPlayer
@export var audio : AudioStreamPlayer2D
@export var state_machine : StateMachine
@export var speed : float = 400
@export var is_hurt := false
@export var is_dead := false

@onready var avatar2d : Sprite2D = $Avatar2D
@onready var hitbox : HitBox2D = $Hitbox2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var equipment : Node2D = $Equipment
var facing_left := false


func _ready():
	#name = stats.name
	var items = equipment.find_children('*', 'Equipable', false)
	for item in items:
		item.equip(self)
	state_machine.init(self, animator)


func _process(delta):
	if state_machine.is_active:
		state_machine.process(delta)


func _physics_process(delta):
	if state_machine.is_active:
		change_face(velocity.x)
		state_machine.physics_process(delta)
		move_and_slide()


func _unhandled_input(event):
	if state_machine.is_active:
		state_machine.input(event)


func change_face(vector: float):
	if vector < 0:
		facing_left = true
	elif vector > 0:
		facing_left = false
	avatar2d.flip_h = facing_left
	

func die():
	hitbox.monitoring = false
	hitbox.monitorable = false
	shape.disabled = true


func _on_hitbox_active(health_update: int):
	is_hurt = true
	if health_update <= 0:
		is_dead = true

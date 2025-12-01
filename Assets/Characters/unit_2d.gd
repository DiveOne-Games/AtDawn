class_name Unit2D extends Controller2D

@export_enum('Idle', 'Patrol') var initial_state: int

var direction: Vector2
var origin : Vector2
var target : CharacterBody2D
var health : int

@onready var shape2d: CollisionShape2D = $CollisionShape2D


func _on_react_zone_target_updated(unit: CharacterBody2D):
	target = unit
	state_machine.target = unit  # TODO: Dont like dup. Pick: this or character.target


func change_face(vector: float):
	super(vector)
	if target:
		if target.global_position.x < global_position.x:
			facing_left = true
		elif target.global_position.x > global_position.x:
			facing_left = false
		sprite.flip_h = facing_left
	

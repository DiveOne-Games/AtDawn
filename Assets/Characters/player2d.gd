class_name Player2D extends CharacterBody2D

signal health_changed

@export var health: int = 100 :
	set(val):
		health = val
		health_changed.emit()
@export var speed: float = 15
@export_enum('Idle', 'Patrol') var initial_state: int

var direction: Vector2
var origin : Vector2
var target : CharacterBody2D
var facing_left := false
var equipment : Array

@onready var state_machine : BehaviorMachine = %BehaviorMachine
@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D
@onready var equipment_node : Node2D = %Equipment


func _ready():
	origin = global_position
	state_machine.init(self, animator, initial_state)
	equipment = equipment_node.get_children() as Array[Equipable]
	for item in equipment:
		equip(item)


func _physics_process(_delta: float) -> void:
	direction = get_last_motion()
	if target:
		sprite.flip_h = target.global_position.x < global_position.x
	facing_left = sprite.flip_h
	move_and_slide()


func _on_react_zone_target_updated(unit: CharacterBody2D):
	target = unit
	state_machine.target = unit  # TODO: Testing, might not be best approach.


func equip(item):
	item.equip(self)


func update_health(amount):
	health += amount
	health_changed.emit()

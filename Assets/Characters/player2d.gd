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
var equipment : Array
var facing_left := false
var is_dead := false

@onready var state_machine : BehaviorMachine = %BehaviorMachine
@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D
@onready var equipment_node : Node2D = %Equipment
@onready var hitbox : Area2D = $HitBox
@onready var shape2d: CollisionShape2D = $CollisionShape2D


func _ready():
	origin = global_position
	state_machine.init(self, animator, initial_state)
	equipment = equipment_node.get_children() as Array[Equipable]
	for item in equipment:
		equip(item)


func _physics_process(_delta: float) -> void:
	if is_dead: return
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
	state_machine.update_state(state_machine.hurt)
	health_changed.emit()


func die():
	is_dead = true
	target = null
	velocity = Vector2.ZERO
	hitbox.monitorable = false
	hitbox.monitoring = false
	shape2d.disabled = true
	for item in equipment:
		item.disable()

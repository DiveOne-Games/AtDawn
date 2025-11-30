class_name Player2D extends CharacterBody2D

signal character_died

@export var stats: PlayerStats
@export_enum('Idle', 'Patrol') var initial_state: int

var direction: Vector2
var origin : Vector2
var target : CharacterBody2D
var equipment : Array
var facing_left := false
var is_dead : bool = false:
	set(val):
		is_dead = val
		character_died.emit()
var is_hurt := false
var health : int

@onready var state_machine : BehaviorMachine = $BehaviorMachine
@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D
@onready var equipment_node : Node2D = %Equipment
@onready var hitbox : Area2D = $Hitbox2D
@onready var shape2d: CollisionShape2D = $CollisionShape2D


func _ready():
	origin = global_position
	state_machine.init(self, animator, initial_state)
	equipment = equipment_node.get_children() as Array[Equipable]
	for item in equipment:
		item.equip(self)


func _physics_process(_delta: float) -> void:
	health = hitbox.health
	if is_dead: return
	direction = get_last_motion()
	if target:
		sprite.flip_h = target.global_position.x < global_position.x
	facing_left = sprite.flip_h

	move_and_slide()


func _on_react_zone_target_updated(unit: CharacterBody2D):
	target = unit
	state_machine.target = unit  # TODO: Testing, might not be best approach.


func die():
	is_dead = true
	target = null
	velocity = Vector2.ZERO
	hitbox.monitorable = false
	hitbox.monitoring = false
	shape2d.disabled = true
	for item in equipment:
		item.disable()


## Event usually triggered by a hitbox such as [HitBox2D].
func _on_hitbox_active(health_update: int):
	is_hurt = true
	if health_update <= 0:
		is_dead = true

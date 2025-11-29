@tool
class_name AudioListenerArea extends Area2D

signal shape_changed

@export var shape_size: Vector2 :
	set(val): update_shape(val)
@export var active: bool = false

@onready var shape2d: CollisionShape2D = %CollisionShape2D
@onready var listener: AudioListener2D = %AudioListener2D


func _ready():
	if shape_size:
		shape2d.shape.size = shape_size


func update_shape(updated_size: Vector2):
	shape2d.shape.size = updated_size
	shape2d.queue_redraw()
	shape_changed.emit()


func _on_body_entered(body: Node2D):
	if body is PlayerCharacter and not active:
		active = true
		listener.make_current()


func _on_body_exited(body: Node2D):
	if body is PlayerCharacter and active:
		active = false
		listener.clear_current()

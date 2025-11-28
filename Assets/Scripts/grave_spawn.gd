extends Sprite2D


@export var unit: PackedScene
@export var count_down: float

@onready var timer : Timer = %Timer

func _ready():
	timer.wait_time = count_down


func _on_timer_timeout():
	var u = unit.instantiate()
	u.global_position = global_position
	get_parent().add_child(u)

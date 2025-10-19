class_name PlayerInput extends IMovable


func get_direction() -> Vector2:
	var v = Vector2(Input.get_axis("move_left", 'move_right'), Input.get_axis('move_up', 'move_down'))
	return v


func get_velocity() -> Vector2:
	return Vector2.ZERO

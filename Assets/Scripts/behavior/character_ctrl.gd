class_name CharacterController extends IMovable

var direction : Vector2


func get_direction() -> Vector2:
	if character.is_on_wall():
		direction *= -1
	return direction


func get_velocity() -> Vector2:
	return Vector2.ZERO

class_name PlayerInputController extends IMovable

var direction: Vector2


func get_direction() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func get_velocity() -> Vector2:
	return character.velocity


func get_input(event: InputEvent):
	return null

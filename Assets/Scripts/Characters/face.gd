extends Sprite2D


func _on_velocity_changed(velocity: Vector2):
	if velocity.x < 0:
		flip_h = true
	elif velocity.x > 0:
		flip_h = false

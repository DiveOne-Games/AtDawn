extends Sprite2D


func _on_velocity_changed(velocity: Vector2):
	flip_h = velocity.x < 0

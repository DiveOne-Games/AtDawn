extends CanvasLayer


var health_bar : ProgressBar


func _ready():
	health_bar = get_node("MarginContainer/HBoxContainer/Health/HealthBar") 


func _on_player_update_health(value: int, max_value: int):
	health_bar.max_value = max_value
	health_bar.value = value


extends CanvasLayer


var health_bar : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = get_node("MarginContainer/HBoxContainer/Health/HealthBar") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_update_health(value: int, max_value: int):
	health_bar.max_value = max_value
	health_bar.value = value


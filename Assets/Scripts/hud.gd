extends CanvasLayer


var health_bar : ProgressBar
var score : Label
var max_digits : int = 7
var score_display : String


func _ready():
	health_bar = get_node("MarginContainer/HBoxContainer/Health/HealthBar") 
	score = get_node("MarginContainer/HBoxContainer/Score")
	pad_score()


func pad_score():
	var digits = len(score.text)
	score_display = ''
	if digits < max_digits:
		var diff = max_digits - digits
		for i in range(diff):
			score_display += '0'
		score_display += score.text
	score.text = score_display
	

func _on_player_update_health(value: int, max_value: int):
	health_bar.max_value = max_value
	health_bar.value = value


func _on_events_update_score(value):
	var new_score : int = int(score.text) + value
	score.text = str(new_score)
	pad_score()


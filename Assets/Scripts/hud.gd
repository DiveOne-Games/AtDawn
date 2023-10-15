extends CanvasLayer


var health_bar : ProgressBar
var score : Label
var max_digits : int = 7
var score_display : String

var target_label : Label
var target_bar : ProgressBar


func _ready():
	health_bar = get_node("MarginContainer/HBoxContainer/Health/HealthBar") 
	target_label = get_node("MarginContainer/HBoxContainer/TargetHealth")
	target_bar = get_node("MarginContainer/HBoxContainer/TargetHealth/HealthBar")
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
	

func set_target(target):
	target_label.text = target.name
	target_bar.max_value = target.max_health
	target_bar.value = target.health
	target_bar.visible = true


func _on_target_update_health(value: int, max_value: int):
	target_bar.max_value = max_value
	target_bar.value = value


func _on_player_update_health(value: int, max_value: int):
	health_bar.max_value = max_value
	health_bar.value = value


func _on_events_update_score(value):
	var new_score : int = int(score.text) + value
	score.text = str(new_score)
	pad_score()


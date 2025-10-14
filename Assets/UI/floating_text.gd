extends Control

enum { SHOW, HIDE }
var text: String
var state = HIDE

@onready var label : RichTextLabel = $MarginContainer/RichTextLabel


func _process(_delta):
	label.text = "[shake rate=20.0 level=5][i]%s[/i][/shake]" % text
	match state:
		SHOW:
			update_text()


func update_text():
	state = HIDE
	label.visible = true
	text_float()
	await get_tree().create_timer(0.5).timeout
	label.visible = false


func text_float():
	var tween = create_tween()
	tween.tween_property(label, "position", Vector2(0,5), 0.5)


func _on_destructible_object_destroyed(points_scored: int):
	text = str(points_scored)
	state = SHOW

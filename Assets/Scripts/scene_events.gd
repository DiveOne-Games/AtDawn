extends Node2D


signal new_unit

# Track units for score values
var hostile_units : Array
var hud : CanvasLayer


func _ready():
	hud = get_parent().get_node('HUD')


func register_unit(unit):
	unit.update_kill_score.connect(hud._on_events_update_score)

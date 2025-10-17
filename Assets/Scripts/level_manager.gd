class_name LevelManager extends Node


@onready var hud : CanvasLayer = $HUD
@onready var anim_player : AnimationPlayer = $AnimationPlayer

var hostile_units : Array
var is_faded := false

const ENEMY_NODE := 'Enemies'


func _ready():
	randomize()
	anim_player.play("scene_fade")
	call_deferred('initialize_units')


func register_unit(unit):
	unit.update_kill_score.connect(hud._on_events_update_score)


func initialize_units():
	var enemies  = get_tree().get_nodes_in_group('enemies')
	for unit in enemies:
		print_debug('Registered ', unit)
		register_unit(unit)
	print_debug('Registered ', len(enemies), ' units.')


func _on_spawn_point_register_new_unit(unit):
	register_unit(unit)


func scene_transition(to: PackedScene, in_vfx = null, out_vfx = null):
	# play out effect here
	get_tree().change_scene_to_packed(to)
	# play in effect here

class_name GameManager
extends Node2D


@onready var tilemap : TileMapLayer = $"../base"
@onready var camera : Camera2D 


func _ready():
	camera = get_parent().find_child('Player').get_node('Camera2D')
	assert(camera, "Camera not found.")
	setup_camera()


func load_game():
	pass 
	
	
func save_game():
	pass
	

func setup_camera():
	var level_limits = tilemap.get_used_rect()
	var tile_cell_size = tilemap.tile_set.tile_size.x 
	camera.limit_left = level_limits.position.x * tile_cell_size
	camera.limit_top = level_limits.position.y * tile_cell_size
	camera.limit_right = level_limits.end.x * tile_cell_size
	camera.limit_bottom = level_limits.end.y * tile_cell_size

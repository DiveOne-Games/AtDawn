extends Node


@onready var player: CharacterBody2D = get_node('Player')
@onready var world: TileMap = get_node('"TileMap"')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func test_player_collides_with_walls():
	Input.action_press('move_right')

	# assert player is touching the wall
	assert(player.collision_layer)

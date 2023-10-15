class_name GameManager
extends Node2D


@export var game_levels : Array[String]


func load_game():
	pass 
	
	
func save_game():
	pass
	

func add_new_level(level):
	game_levels.append(level)
	

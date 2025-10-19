class_name Equipable extends Area2D

@export var item : Weapon

var user : CharacterBody2D


func equip(_owner: CharacterBody2D):
	user = _owner

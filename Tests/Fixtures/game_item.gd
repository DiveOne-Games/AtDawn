class_name GameItem
extends Resource 


enum ItemType { Gold, Collectible, Equipment }

@export var item_name : String
@export var item_desc : String
@export var value: int
@export var item_icon : Texture2D
@export var sprite : Texture2D
@export var use_region := false
@export var frame : int
@export var frame_coords : Vector2i
@export var item_type : ItemType
@export var sfx : AudioStream

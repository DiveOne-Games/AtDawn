extends Node2D

@export var messages : Array[String] = [
	"Where you think you're going? Don't be foolish! In the BEST of times, there's nothing but the dead down there ...",
]
@onready var label : RichTextLabel = $Control/RichTextLabel
@onready var timer : Timer = $Control/Timer


func _on_merchant_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	for msg in messages:
		for letter in msg:
			label.append_text(letter)
			await timer.timeout

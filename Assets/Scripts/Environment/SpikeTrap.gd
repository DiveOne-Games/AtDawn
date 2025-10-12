extends StaticBody2D

var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $AnimationPlayer


func _physics_process(_delta):
	if not animation_player.is_playing():
		animation_player.play("active")


func _on_area_2d_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print_debug('SpikeTrap area was entered by ', area)
	if is_instance_of(area, HitBox):
		area.take_damage(damage)

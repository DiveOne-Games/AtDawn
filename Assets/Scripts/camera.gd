class_name PlayerCamera extends Camera2D

const CAMERA_ZOOM = 'camera_in'
const CAMERA_UNZOOM = 'camera_out'
const MIN_ZOOM : float = 0.5
const MAX_ZOOM : float = 5
const ZOOM_INCREMENT : float = 0.25

@export_range(MIN_ZOOM, MAX_ZOOM, ZOOM_INCREMENT) var camera_zoom: float = 1
var zoom_in := false 
var zoom_out := false


func _physics_process(_delta):
	zoom = Vector2(camera_zoom, camera_zoom)
	if zoom_in:
		camera_zoom += 0.1
		zoom_in = false
	if zoom_out:
		camera_zoom -= 0.1
		zoom_out = false

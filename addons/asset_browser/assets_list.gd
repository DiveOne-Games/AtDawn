extends Control

var assets : Array
var assets_path : String
var default_path = 'res://Assets/Characters/'
@onready var container : HFlowContainer = $VFlowContainer/HFlowContainer
@onready var text_editor: TextEdit = $VFlowContainer/VBoxContainer/TextEdit
@onready var load_btn: Button

var has_path := false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not assets_path:
		assets_path = default_path
	var characters = DirAccess.get_files_at(assets_path)	
#	unpack_files(characters)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func unpack_files(dir: Array):
	for asset in dir:
		print('Asset ', asset)
		var node = load(assets_path + asset).instantiate()
		container.add_child(node)


func _on_button_pressed():
	assets_path = text_editor.text
	assets = DirAccess.get_files_at(assets_path)
	unpack_files(assets)

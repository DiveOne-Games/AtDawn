@tool
extends EditorPlugin


var browser


func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	browser = preload("res://addons/asset_browser/asset_browser.tscn").instantiate()

	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_BL, browser)
	# Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(browser)
	# Erase the control from the memory.
	browser.free()

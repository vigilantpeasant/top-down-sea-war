extends Node2D

func _ready():
	GUI.show()
	GUI.load_scene()
	GUI.settings_menu.update_ui()

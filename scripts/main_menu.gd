extends Control

func _ready():
	GUI.hide()
	$Version.text = str(Data.version)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_exit_pressed():
	get_tree().quit()

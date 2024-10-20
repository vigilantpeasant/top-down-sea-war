extends Control

func _ready():
	$Version.text = str(Data.version)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")

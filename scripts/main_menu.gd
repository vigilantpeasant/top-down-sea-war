extends Control
@onready var action_menu = $"Action Menu"
@onready var settings_menu = $"Settings Menu"

func _ready():
	GUI.hide()
	$Version.text = str(Data.version)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(action_menu, "position", Vector2(-176, -8), 0.2)
	tween.tween_property(settings_menu, "position", Vector2(40, 28), 0.2)

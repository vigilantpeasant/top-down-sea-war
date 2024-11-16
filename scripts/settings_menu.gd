extends Panel

@onready var action_menu = get_tree().get_root().get_node("Main Menu/Action Menu")
@onready var pause = GUI.get_node("UI/Pause")
@onready var vsync_button = $"GridContainer/Vsync Button"
@onready var anti_aliasing_option = $"GridContainer/AntiAliasing Option"

func _ready():
	update_ui()

func update_ui():
	vsync_button.button_pressed = Data.is_vsync
	match Data.anti_aliasing:
		0: # No anti-aliasing
			anti_aliasing_option.selected = 0  
		2: # 2x anti-aliasing
			anti_aliasing_option.selected = 1  
		4: # 4x anti-aliasing
			anti_aliasing_option.selected = 2  
		8: # 8x anti-aliasing
			anti_aliasing_option.selected = 3

func _on_back_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(1038, 28), 0.2)
	
	if get_tree().current_scene.name == "Main Menu":
		tween.tween_property(action_menu, "position", Vector2(128, -8), 0.2)
	else:
		tween.tween_property(pause, "position", Vector2(360, -8), 0.2)

func _on_vsync_button_pressed():
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		Data.is_vsync = false
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		Data.is_vsync = true

func _on_anti_aliasing_option_item_selected(index):
	match index:
		0: # No anti-aliasing
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 0)
			Data.anti_aliasing = 0
		1: # 2x anti-aliasing
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 2)
			Data.anti_aliasing = 2
		2: # 4x anti-aliasing
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 4)
			Data.anti_aliasing = 4
		3: # 8x anti-aliasing
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_2d", 8)
			Data.anti_aliasing = 8

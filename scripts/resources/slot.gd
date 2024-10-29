extends Button

@export var item: Item = null:
	set(value):
		if item != null:
			if value == null:
				var hotbar = get_parent()
				hotbar.player.update_firing_rates()
		
		item = value
		
		if value != null:
			icon = value.icon
		else:
			icon = null

func _on_mouse_entered():
	if item != null:
		Tooltips.ItemPopup(Rect2i(Vector2i(global_position), Vector2i(size)), item)

func _on_mouse_exited():
	Tooltips.HideItemPopup()

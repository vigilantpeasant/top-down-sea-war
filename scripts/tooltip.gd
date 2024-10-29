extends Control

var rarity_colors = {
	"Legendary": Color(1, 0.843, 0),  # Gold
	"Rare": Color(0, 0.5, 1),        # Blue
	"Uncommon": Color(0.5, 1, 0),     # Green
	"Common": Color(1, 1, 1),          # White
}

func ItemPopup(slot, item : Item):
	if item != null:
		set_value(item)
		%ItemPopUp.size = Vector2i.ZERO
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction
	var padding = 4
	
	if mouse_pos.x <= get_viewport_rect().size.x /2:
		correction = Vector2i(slot.size.x + padding, 0)
	else:
		correction = Vector2i(%ItemPopUp.size.x + padding, 0)
	
	%ItemPopUp.popup(Rect2i(slot.position + correction, %ItemPopUp.size))

func HideItemPopup():
	%ItemPopUp.hide()

func set_value(item : Item):
	%Name.text = item.name
	%Rarity.text = item.rarity
	%RateOfFireValue.text = str(item.rate_of_fire)
	%DamageValue.text = str(item.damage)
	
	if rarity_colors.has(item.rarity):
		%Rarity.label_settings.font_color = rarity_colors[item.rarity]
	else:
		%Rarity.label_settings.font_color = Color(1, 1, 1)

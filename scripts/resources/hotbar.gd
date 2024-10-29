extends Panel

@onready var left_weapon_slot = $slot
@onready var right_weapon_slot = $slot2
var player

func find_player():
	player = get_tree().get_root().get_node("Map/Ship")

func add_item(items):
	find_player()
	
	# Add item to the appropriate weapon slot
	if left_weapon_slot.item == null:
		left_weapon_slot.item = items
	elif right_weapon_slot.item == null:
		right_weapon_slot.item = items
	
	# Update firing rates after adding the item
	player.update_firing_rates()

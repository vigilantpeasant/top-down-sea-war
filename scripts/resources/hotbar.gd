extends Panel

@onready var left_weapon_slot = $slot
@onready var right_weapon_slot = $slot2
@onready var thing : int = 0
var player

func find_player():
	player = get_tree().get_root().get_node("Map/Ship")
	return player

func find_pickup_node():
	var pickups = get_tree().get_nodes_in_group("PickUp")
	return pickups

func add_item(items):
	find_player()
	
	if thing < 2:
		thing = thing + 1
		# Add item to the appropriate weapon slot
		if left_weapon_slot.item == null:
			left_weapon_slot.item = items
		elif right_weapon_slot.item == null:
			right_weapon_slot.item = items
		
		# Update firing rates after adding the item
		player.update_firing_rates()

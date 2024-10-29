extends CanvasLayer

@onready var inventory_panel = $UI/Hotbar
@onready var stats = $UI/Stats
@onready var info = $UI/Info
var inventory_open = false
var info_open = true

func _ready():
	# Update ui initially
	update_ui()

func update_ui():
	# Update stats menu
	$UI/Stats/VBoxContainer/MaxSpeed.text = "Max Speed: " + str(Data.ships[Data.current_ship]["max_speed"])
	$UI/Stats/VBoxContainer/Acceleration.text = "Acceleration: " + str(Data.ships[Data.current_ship]["acceleration"])
	$UI/Stats/VBoxContainer/Deceleration.text = "Deceleration: " + str(Data.ships[Data.current_ship]["deceleration"])
	$UI/Stats/VBoxContainer/TurningSpeed.text = "Turning Speed: " + str(Data.ships[Data.current_ship]["turning_speed"])
	
	# Update info menu
	$UI/Info/Coin2D/Coin.text = "Coins: " + str(Data.coin) + "/" + str(Data.max_coin)
	$UI/Info/Crew2D/Crew.text = "Crew: " + str(Data.crew) + "/" + str(Data.max_crew)
	$UI/Info/Boat2D/Health.text = "Health: " + str(Data.health) + "/" + str(Data.max_health)

func _input(event):
	# show/hide inventory
	if event.is_action_pressed("inventory"):
		var tween = get_tree().create_tween()
		if inventory_open:
			tween.tween_property(inventory_panel, "position", Vector2(8, 536 + 256), 0.3)
			tween.tween_property(stats, "position", Vector2(752, 8 - 256), 0.35)
			inventory_open = false
		else:
			tween.tween_property(inventory_panel, "position", Vector2(8, 536), 0.2)
			tween.tween_property(stats, "position", Vector2(752, 8), 0.15)
			inventory_open = true
	
	# show/hide info
	if event.is_action_pressed("tab"):
		var tween = get_tree().create_tween()
		if info_open:
			tween.tween_property(info, "position", Vector2(744, 536 + 256), 0.3)
			info_open = false
		else:
			tween.tween_property(info, "position", Vector2(744, 536), 0.2)
			info_open = true

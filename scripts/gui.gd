extends CanvasLayer

@onready var inventory = $UI/Inventory
@onready var stats = $UI/Stats
@onready var info = $UI/Info
var btooltip = preload("res://scenes/tooltip.tscn")
var inventory_open = false
var info_open = true

func _ready():
	self.visible = true
	$UI/Stats/VBoxContainer/MaxSpeed.text = "Max Speed: " + str(Data.ships[Data.current_ship]["max_speed"])
	$UI/Stats/VBoxContainer/Acceleration.text = "Acceleration: " + str(Data.ships[Data.current_ship]["acceleration"])
	$UI/Stats/VBoxContainer/Deceleration.text = "Deceleration: " + str(Data.ships[Data.current_ship]["deceleration"])
	$UI/Stats/VBoxContainer/TurningSpeed.text = "Turning Speed: " + str(Data.ships[Data.current_ship]["turning_speed"])
	$Version.text = str(Data.version)

func _on_slot_mouse_entered():
	var tooltip = btooltip.instantiate()
	tooltip.global_position = Vector2(224, 448)
	add_child(tooltip)

func _on_slot_mouse_exited():
	get_node("Tooltip").free()

func _input(event):
	# show/hide inventory
	if event.is_action_pressed("inventory"):
		var tween = get_tree().create_tween()
		if inventory_open:
			# closing inventory
			tween.tween_property(inventory, "position", Vector2(8, 536 + 256), 0.3)
			tween.tween_property(stats, "position", Vector2(752, 8 - 256), 0.35)
			inventory_open = false
		else:
			# opening inventory
			tween.tween_property(inventory, "position", Vector2(8, 536), 0.2)
			tween.tween_property(stats, "position", Vector2(752, 8), 0.15)
			inventory_open = true
	
	# show/hide info
	if event.is_action_pressed("tab"):
		var tween = get_tree().create_tween()
		if info_open:
			# closing info menu
			tween.tween_property(info, "position", Vector2(744, 536 + 256), 0.3)
			info_open = false
		else:
			# opening info menu
			tween.tween_property(info, "position", Vector2(744, 536), 0.2)
			info_open = true

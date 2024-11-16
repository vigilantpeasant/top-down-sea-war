extends Sprite2D
class_name PickUp

@export var items : Item
@onready var collision = $Area2D/CollisionShape2D
@onready var hotbar = GUI.get_node("UI/Hotbar")
@onready var picked_up_slot = GUI.get_node("UI/Hotbar/Slot")

func _ready():
	if items != null:
		texture = items.icon
		items.adjust_rate_of_fire()

func _on_area_2d_body_entered(body):
	if hotbar.thing < 2:
		body.add_item(items)
		queue_free()
	else:
		GUI.pickup_item.emit()
		picked_up_slot.visible = true
		picked_up_slot.item = items
		GUI.picked_up_item = self

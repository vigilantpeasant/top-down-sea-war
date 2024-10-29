extends Sprite2D
@export var items : Item
@onready var collision = $Area2D/CollisionShape2D

func _ready():
	if items != null:
		texture = items.icon
		items.adjust_rate_of_fire()

func _on_area_2d_body_entered(body):
	body.add_item(items)
	queue_free()

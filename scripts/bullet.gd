extends Area2D

const BULLET_SPEED = 650
var target: Node2D = null
var bullet_range = 600
var travelled_distance = 0
var direction : Vector2

func _ready():
	# Initialize the direction variable
	direction = Vector2.ZERO

func _process(delta):
	# If there is a target, follow it
	if target:
		var bdirection = (target.global_position - global_position).normalized()
		position += bdirection * BULLET_SPEED * delta
	else:
		# If there is no target, move in the initial direction
		position += direction * BULLET_SPEED * delta
	
	travelled_distance += BULLET_SPEED * delta
	if travelled_distance > bullet_range:
		queue_free()

func set_target(target_enemy: Node2D):
	target = target_enemy

func _on_body_entered(_body):
	queue_free()

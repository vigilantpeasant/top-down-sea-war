extends CharacterBody2D

@onready var left_weapon = $LeftWeapon
@onready var right_weapon = $RightWeapon
@onready var ship_2d = $Ship2D
var bullet_scene = preload("res://scenes/bullet.tscn")
var target_indicator = preload("res://scenes/target_indicator.tscn")

var max_speed = Data.ships[Data.current_ship]["max_speed"]
var rotation_speed = Data.ships[Data.current_ship]["turning_speed"]
var direction = Vector2.ZERO
var acceleration = Data.ships[Data.current_ship]["acceleration"]
var deceleration = Data.ships[Data.current_ship]["deceleration"]
var current_speed = 0.0

var left_can_shoot = true
var right_can_shoot = true
var lrate_of_fire = Data.ships[Data.current_ship]["leftw_rate_of_fire"]
var rrate_of_fire = Data.ships[Data.current_ship]["rightw_rate_of_fire"]
var nearest_left_enemy: Node2D = null
var nearest_right_enemy: Node2D = null
var targeted_enemy: Node2D = null
var indicator_instances = {}

func _ready():
	match (Data.current_ship):
		"Cog":
			ship_2d.frame = 0
		"Carrack":
			ship_2d.frame = 1
		"Dhow":
			ship_2d.frame = 2
		"Junk":
			ship_2d.frame = 3
		"Galley":
			ship_2d.frame = 4
		"Knarr":
			ship_2d.frame = 5
		"Drakkar":
			ship_2d.frame = 6

func _physics_process(delta):
	handle_movement(delta)
	handle_firing()

func handle_movement(delta):
	# Handle acceleration and deceleration
	if Input.is_action_pressed("up"):
		current_speed = min(current_speed + acceleration * delta, max_speed)
	elif Input.is_action_pressed("down"):
		current_speed = max(current_speed - acceleration * delta, 0)
	else:
		if current_speed > 0:
			current_speed = max(current_speed - deceleration * delta, 0)
		elif current_speed < 0:
			current_speed = min(current_speed + deceleration * delta, 0)

	# Limit rotation speed when current speed is 0
	var effective_rotation_speed = rotation_speed
	if current_speed == 0:
		effective_rotation_speed *= 0.5
	
	# Handle steering
	if Input.is_action_pressed("left"):
		rotation -= effective_rotation_speed * delta
	elif Input.is_action_pressed("right"):
		rotation += effective_rotation_speed * delta
	
	# Calculate direction and move ship
	direction = Vector2.UP.rotated(rotation) * current_speed
	velocity = direction
	move_and_slide()

func handle_firing():
	# Fire left weapon when left mouse button is pressed
	if Input.is_action_just_pressed("mouse_left") and targeted_enemy and left_can_shoot:
		fire(left_weapon, targeted_enemy, lrate_of_fire)

	# Fire right weapon when right mouse button is pressed
	if Input.is_action_just_pressed("mouse_right") and targeted_enemy and right_can_shoot:
		fire(right_weapon, targeted_enemy, rrate_of_fire)

	# Update indicators for nearest enemies
	update_indicators()

func fire(weapon: Node2D, target_enemy: Node2D, rate_of_fire: float):
	# Create a new bullet
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = weapon.global_position
	new_bullet.global_rotation = weapon.global_rotation
	get_tree().current_scene.add_child(new_bullet)
	
	# Set bullet's direction based on targeted enemy or default direction
	if target_enemy:
		new_bullet.set_target(target_enemy)
	else:
		if weapon == left_weapon:
			new_bullet.direction = Vector2.LEFT.rotated(global_rotation)
		else:
			new_bullet.direction = Vector2.RIGHT.rotated(global_rotation)
	
	# Disable shooting for the respective weapon
	if weapon == left_weapon:
		left_can_shoot = false
		await get_tree().create_timer(rate_of_fire).timeout
		left_can_shoot = true
	else:
		right_can_shoot = false
		await get_tree().create_timer(rate_of_fire).timeout
		right_can_shoot = true

func update_indicators():
	# Clear indicators for enemies no longer in range
	for enemy in indicator_instances.keys():
		if not $LeftOverlap.get_overlapping_bodies().has(enemy) and not $RightOverlap.get_overlapping_bodies().has(enemy):
			clear_indicator(enemy)
	
	# Show indicators for new enemies in range
	for enemy in $LeftOverlap.get_overlapping_bodies():
		if enemy.is_in_group("Enemy"):
			show_indicator(enemy)
	for enemy in $RightOverlap.get_overlapping_bodies():
		if enemy.is_in_group("Enemy"):
			show_indicator(enemy)

func show_indicator(enemy: Node2D):
	# Create and show indicator for enemy
	if enemy not in indicator_instances:
		var indicator_instance = target_indicator.instantiate()
		indicator_instance.global_position = enemy.global_position + Vector2(0, 0)
		get_tree().current_scene.add_child(indicator_instance)
		indicator_instances[enemy] = indicator_instance
	else:
		indicator_instances[enemy].global_position = enemy.global_position + Vector2(0, 0)

func clear_indicator(enemy: Node2D):
	# Remove the indicator for a specific enemy
	if enemy in indicator_instances:
		indicator_instances[enemy].queue_free()
		indicator_instances.erase(enemy)

func _input(event):
	# Handle mouse clicks for targeting enemies
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		var mouse_position = get_global_mouse_position()
		var closest_enemy = null
		var closest_distance = INF
		
		# Check for closest enemy in both overlap areas
		for enemy in $LeftOverlap.get_overlapping_bodies() + $RightOverlap.get_overlapping_bodies():
			if enemy.is_in_group("Enemy"):
				var distance = enemy.global_position.distance_to(mouse_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_enemy = enemy
		
		# Set the closest enemy as the targeted enemy
		if closest_enemy:
			targeted_enemy = closest_enemy
		else:
			targeted_enemy = null

func _on_left_overlap_body_entered(body):
	if body.is_in_group("Enemy"):
		if not nearest_left_enemy or position.distance_to(body.position) < position.distance_to(nearest_left_enemy.position):
			nearest_left_enemy = body
	update_indicators()

func _on_left_overlap_body_exited(body):
	if body == nearest_left_enemy:
		nearest_left_enemy = null
		clear_indicator(body)
		
		if targeted_enemy == body:
			targeted_enemy = null
	update_indicators()

func _on_right_overlap_body_entered(body):
	if body.is_in_group("Enemy"):
		if not nearest_right_enemy or position.distance_to(body.position) < position.distance_to(nearest_right_enemy.position):
			nearest_right_enemy = body
	update_indicators()

func _on_right_overlap_body_exited(body):
	if body == nearest_right_enemy:
		nearest_right_enemy = null
		clear_indicator(body)
		if targeted_enemy == body:
			targeted_enemy = null
	update_indicators()

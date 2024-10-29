extends CharacterBody2D

@onready var left_weapon = $LeftWeapon
@onready var right_weapon = $RightWeapon
@onready var ship_2d = $Ship2D
@onready var lweapon_bar = GUI.get_node("UI/Hotbar/slot/ProgressBar")
@onready var rweapon_bar = GUI.get_node("UI/Hotbar/slot2/ProgressBar")
@onready var hotbar = GUI.get_node("UI/Hotbar")
var bullet_scene = preload("res://scenes/bullet.tscn")
var target_indicator = preload("res://scenes/target_indicator.tscn")

var max_speed = Data.ships[Data.current_ship]["max_speed"]
var rotation_speed = Data.ships[Data.current_ship]["turning_speed"]
var acceleration = Data.ships[Data.current_ship]["acceleration"]
var deceleration = Data.ships[Data.current_ship]["deceleration"]
var direction = Vector2.ZERO
var current_speed = 0.0

var left_can_shoot = true
var right_can_shoot = true
var lweapon_timer = 0.0
var rweapon_timer = 0.0
var lrate_of_fire = 1.0
var rrate_of_fire = 1.0
var nearest_enemy: Node2D = null
var targeted_enemy: Node2D = null
var indicator_instances = {}

func _ready():
	# Set ship
	match (Data.current_ship):
		"Cog":
			ship_2d.animation = "Cog"
		"Carrack":
			ship_2d.animation = "Carrack"
		"Dhow":
			ship_2d.animation = "Dhow"
		"Junk":
			ship_2d.animation = "Junk"
		"Galley":
			ship_2d.animation = "Galley"
		"Knarr":
			ship_2d.animation = "Knarr"
		"Drakkar":
			ship_2d.animation = "Drakkar"
	
	# Update rate of fire based on weapon
	update_firing_rates()

func _physics_process(delta):
	handle_movement(delta)
	handle_firing()
	update_weapon_bars(delta)

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
	# Fire left weapon when left mouse button is pressed, left item is equipped, and left_can_shoot is true
	if Input.is_action_just_pressed("mouse_left") and targeted_enemy and left_can_shoot and hotbar.left_weapon_slot.item:
		fire(left_weapon, targeted_enemy)
	
	# Fire right weapon when right mouse button is pressed, right item is equipped, and right_can_shoot is true
	if Input.is_action_just_pressed("mouse_right") and targeted_enemy and right_can_shoot and hotbar.right_weapon_slot.item:
		fire(right_weapon, targeted_enemy)
	
	# Update indicators for nearest enemies
	update_indicators()

func fire(weapon: Node2D, target_enemy: Node2D):
	# Create a new bullet
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = weapon.global_position
	new_bullet.global_rotation = weapon.global_rotation
	get_tree().current_scene.add_child(new_bullet)
	
	# Set bullet's direction based on targeted enemy or default direction
	if target_enemy:
		new_bullet.set_target(target_enemy)
	else:
		# Default direction
		new_bullet.direction = Vector2.UP.rotated(global_rotation)

	# Set rate of fire based on weapon type
	if weapon == left_weapon:
		left_can_shoot = false
		lweapon_timer = lrate_of_fire
		lweapon_bar.value = 0
	else:
		right_can_shoot = false
		rweapon_timer = rrate_of_fire
		rweapon_bar.value = 0

func update_firing_rates():
	var left_item = hotbar.left_weapon_slot.item
	var right_item = hotbar.right_weapon_slot.item
	
	if left_item != null:
		left_can_shoot = true
		lrate_of_fire = left_item.rate_of_fire
	else:
		left_can_shoot = false
		lrate_of_fire = 1.0

	if right_item != null:
		right_can_shoot = true
		rrate_of_fire = right_item.rate_of_fire
	else:
		right_can_shoot = false
		rrate_of_fire = 1.0

func update_weapon_bars(delta):
	# Update left and right weapons cooldown
	if not left_can_shoot:
		lweapon_timer -= delta
		lweapon_bar.value = 100 * (1 - lweapon_timer / lrate_of_fire)
		if lweapon_timer <= 0:
			left_can_shoot = true
			lweapon_bar.value = 0
	
	if not right_can_shoot:
		rweapon_timer -= delta
		rweapon_bar.value = 100 * (1 - rweapon_timer / rrate_of_fire)
		if rweapon_timer <= 0:
			right_can_shoot = true
			rweapon_bar.value = 0

func add_item(items):
	hotbar.add_item(items)

func update_indicators():
	# Clear indicators for enemies no longer in range
	for enemy in indicator_instances.keys():
		if not $WeaponOverlay.get_overlapping_bodies().has(enemy):
			clear_indicator(enemy)
	
	# Show indicators for new enemies in range
	for enemy in $WeaponOverlay.get_overlapping_bodies():
		if enemy.is_in_group("Enemy"):
			show_indicator(enemy)

func show_indicator(enemy: Node2D):
	# Create and show indicator for enemy
	if enemy not in indicator_instances:
		var indicator_instance = target_indicator.instantiate()
		indicator_instance.global_position = enemy.global_position + Vector2(0, 0)
		get_tree().current_scene.add_child.call_deferred(indicator_instance)
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
		
		# Check for closest enemy in the overlay area
		for enemy in $WeaponOverlay.get_overlapping_bodies():
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

func _on_overlay_body_entered(body):
	if body.is_in_group("Enemy"):
		if not nearest_enemy or position.distance_to(body.position) < position.distance_to(nearest_enemy.position):
			nearest_enemy = body
	update_indicators()

func _on_overlay_body_exited(body):
	if body == nearest_enemy:
		nearest_enemy = null
		clear_indicator(body)
		
		if targeted_enemy == body:
			targeted_enemy = null
	update_indicators()

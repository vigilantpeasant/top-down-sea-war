extends CanvasLayer

signal pickup_item

@onready var player
@onready var hotbar = $UI/Hotbar
@onready var info = $UI/Info
@onready var pickup = PickUp.new() as PickUp
@onready var settings_menu = $"UI/Settings Menu"
@onready var pause = $UI/Pause

var pickup_node
var info_open = true
var picked_up_item : PickUp = null
var pause_menu = false

func _ready():
	connect("pickup_item", Callable(self, "_on_pickup_item"))
	update_ui()

func _process(_delta):
	$UI/FPS.text = str(Engine.get_frames_per_second())

func _on_pickup_item():
	$UI/Prompts.visible = true
	get_tree().create_tween().tween_property(hotbar, "position", Vector2(416, 275), 0.1)
	await get_tree().create_timer(0.1).timeout
	Engine.time_scale = 0

func close_pickup_item():
	$UI/Hotbar/Slot.visible = false
	$UI/Prompts.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(hotbar, "position", Vector2(0, 550), 0.1)
	Engine.time_scale = 1

func update_ui():
	# Update info menu
	$UI/Info/Coin2D/Coin.text = str(Data.coin) + "/" + str(Data.max_coin)
	$UI/Info/Crew2D/Crew.text = str(Data.crew) + "/" + str(Data.max_crew)
	$UI/Info/Boat2D/Health.text = str(Data.health) + "/" + str(Data.max_health)

func save_scene():
	var data = SceneData.new()
	hotbar.find_player()
	pickup_node = hotbar.find_pickup_node()
	player = hotbar.player
	
	for pk in pickup_node:
		var pickup_scene = PackedScene.new()
		pickup_scene.pack(pk)
		data.pickup_array.append(pickup_scene)
	
	data.player_position = player.global_position
	data.player_rotation = player.rotation
	data.left_weapon_slot_item = hotbar.left_weapon_slot.item
	data.right_weapon_slot_item = hotbar.right_weapon_slot.item
	data.weapon_limit = hotbar.thing
	ResourceSaver.save(data, "user://scene_data.tres")

func load_scene():
	hotbar.find_player()
	pickup_node = hotbar.find_pickup_node()
	player = hotbar.player
	
	var data = ResourceLoader.load("user://scene_data.tres") as SceneData
	if data == null:
		return

	player.global_position = data.player_position
	player.rotation = data.player_rotation
	hotbar.left_weapon_slot.item = data.left_weapon_slot_item
	hotbar.right_weapon_slot.item = data.right_weapon_slot_item
	hotbar.thing = data.weapon_limit
	
	# Only clear existing pickups if there are saved pickups to load
	if data.pickup_array.size() > 0:
		for pk in pickup_node:
			pk.queue_free()
		
		# Load saved pickups from pickup_array
		for pk in data.pickup_array:
			var pk_node = pk.instantiate()
			get_tree().current_scene.add_child(pk_node)
			pk_node.add_to_group("PickUp")
	
	hotbar.player.update_firing_rates()

func _input(event):
	# Handling escape key
	if event.is_action_pressed("escape") and get_tree().current_scene.name != "Main Menu":
		if Engine.time_scale == 0:
			close_pickup_item()
		else:
			toggle_pause_menu()

func _on_left_slot_pressed():
	# Adding new left weapons to left weapon slot
	if Engine.time_scale == 0:
		if picked_up_item != null and hotbar.left_weapon_slot.item != null:
			hotbar.left_weapon_slot.item = picked_up_item.items
			hotbar.find_player()
			hotbar.player.update_firing_rates()
			hotbar.player.reset_weapon_bars()
			picked_up_item.queue_free()
			close_pickup_item()

func _on_right_slot_pressed():
	# Adding new right weapons to right weapon slot
	if  Engine.time_scale == 0:
		if picked_up_item != null and hotbar.right_weapon_slot.item != null:
			hotbar.right_weapon_slot.item = picked_up_item.items
			hotbar.find_player()
			hotbar.player.update_firing_rates()
			hotbar.player.reset_weapon_bars()
			picked_up_item.queue_free()
			close_pickup_item()

func toggle_pause_menu():
	pause_menu = !pause_menu
	if pause_menu:
		hotbar.visible = false
		info.visible = false
		get_tree().create_tween().tween_property(pause, "position", Vector2(360, -8), 0.1)
	else:
		hotbar.visible = true
		info.visible = true
		get_tree().create_tween().tween_property(pause, "position", Vector2(-480, -8), 0.1)

func _on_resume_pressed():
	toggle_pause_menu()

func _on_settings_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(pause, "position", Vector2(-480, -8), 0.1)
	tween.tween_property(settings_menu, "position", Vector2(40, 28), 0.1)

func _on_exitnsave_pressed():
	toggle_pause_menu()
	save_scene()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exitwithoutsave_pressed():
	toggle_pause_menu()
	hotbar.left_weapon_slot.item = null
	hotbar.right_weapon_slot.item = null
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

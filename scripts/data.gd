extends Node
var version = "v1.5"

var current_ship = "Cog"
var health = 0
var max_health = 10
var crew = 0
var max_crew = 4
var coin = 0
var max_coin = 1000

var ships = {
	"Drakkar": {
		"max_speed": 325.0,
		"acceleration": 300.0,
		"deceleration": 300.0,
		"turning_speed": 2.0,
		"health": 13,
		"crew": 8,
		"coin": 2250,
	},
	"Knarr": {
		"max_speed": 300.0,
		"acceleration": 175.0,
		"deceleration": 175.0,
		"turning_speed": 1.4,
		"health": 10,
		"crew": 4,
		"coin": 2000,
	},
	"Galley": {
		"max_speed": 250.0,
		"acceleration": 325.0,
		"deceleration": 325.0,
		"turning_speed": 2.25,
		"health": 13,
		"crew": 12,
		"coin": 2500,
	},
	"Junk": {
		"max_speed": 200.0,
		"acceleration": 200.0,
		"deceleration": 200.0,
		"turning_speed": 1.5,
		"health": 15,
		"crew": 12,
		"coin": 3000,
	},
	"Dhow": {
		"max_speed": 175.0,
		"acceleration": 250.0,
		"deceleration": 250.0,
		"turning_speed": 1.75,
		"health": 17,
		"crew": 8,
		"coin": 2750,
	},
	"Carrack": {
		"max_speed": 150.0,
		"acceleration": 150.0,
		"deceleration": 150.0,
		"turning_speed": 1.2,
		"health": 20,
		"crew": 16,
		"coin": 3500,
	},
	"Cog": {
		"max_speed": 140.0,
		"acceleration": 140.0,
		"deceleration": 140.0,
		"turning_speed": 1.3,
		"health": 20,
		"crew": 16,
		"coin": 3500,
	}
}

func _ready():
	setting_ship(current_ship)

func setting_ship(ship_name: String):
	if ships.has(ship_name):
		max_health = ships[ship_name]["health"]
		max_crew = ships[ship_name]["crew"]
		max_coin = ships[ship_name]["coin"]
		
		health = max_health

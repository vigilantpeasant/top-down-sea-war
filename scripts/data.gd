extends Node
var version = "pre-alpha 1.3"
var current_ship = "Galley"

var ships = {
	"Drakkar": {
		"max_speed": 325.0,
		"acceleration": 300.0,
		"deceleration": 300.0,
		"turning_speed": 2.0,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0
	},
	"Knarr": {
		"max_speed": 300.0,
		"acceleration": 175.0,
		"deceleration": 175.0,
		"turning_speed": 1.4,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0
	},
	"Galley": {
		"max_speed": 250.0,
		"acceleration": 325.0,
		"deceleration": 325.0,
		"turning_speed": 2.25,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0
	},
	"Junk": {
		"max_speed": 200.0,
		"acceleration": 200.0,
		"deceleration": 200.0,
		"turning_speed": 1.5,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0
	},
	"Dhow": {
		"max_speed": 175.0,
		"acceleration": 250.0,
		"deceleration": 250.0,
		"turning_speed": 1.75,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0
	},
	"Carrack": {
		"max_speed": 150.0,
		"acceleration": 150.0,
		"deceleration": 150.0,
		"turning_speed": 1.2,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0,
	},
	"Cog": {
		"max_speed": 140.0,
		"acceleration": 140.0,
		"deceleration": 140.0,
		"turning_speed": 1.3,
		"leftw_rate_of_fire": 1.0,
		"rightw_rate_of_fire": 1.0,
	}
}

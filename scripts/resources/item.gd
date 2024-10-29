class_name Item
extends Resource

@export var name: String
@export var icon: Texture2D
@export_enum("Legendary", "Rare", "Uncommon", "Common") var rarity : String
@export var rate_of_fire : float
@export var damage : int
var is_adjusted = false

var rarity_multiplier = {
	"Legendary": 0.5,
	"Rare": 0.75,
	"Uncommon": 0.9,
	"Common": 1.0
}

func adjust_rate_of_fire():
	if not is_adjusted:
		var adjusted_rate_of_fire = rate_of_fire * (rarity_multiplier.get(rarity, 1.0))
		rate_of_fire = adjusted_rate_of_fire
		is_adjusted = true

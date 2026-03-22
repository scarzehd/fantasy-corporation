extends Resource
class_name BasicItemGenerator

@export var power_range:Vector2i
@export var power_deviation:float = 0.5
@export var attack_range:Vector2i
@export var attack_deviation:float = 0.5
@export var defense_range:Vector2i
@export var defense_deviation:float = 0.5
@export var hp_range:Vector2i
@export var hp_deviation:float = 0.5
@export var weapon_portraits:Array[Texture2D]
@export var armor_portraits:Array[Texture2D]

@export var weapon_types:Array[String] = [
	"Broadsword",
	"Longsword",
	"Shortsword",
	"Hammer",
	"Axe",
	"Greataxe",
	"Slingshot",
	"Crossbow",
	"Flail",
	"Morningstar",
	"Scroll",
	"Mace"
]

@export var descriptions:Array[String] = [
	"Smiting",
	"Holiness",
	"Unholiness",
	"Warding",
	"Warning",
	"Luck",
	"Unluck",
	"Fortune",
	"Misfortune",
	"Destruction",
	"Doom",
	"Death"
]

@export var adjectives:Array[String] = [
	"Heroic",
	"Unheroic",
	"Angelic",
	"Heavy",
	"Light",
	"Quick",
	"Demonic",
	"Hilarious",
	"Sporadic",
	"Mystical",
	"Mythical",
	"Mechanical",
	"Masterful"
]

func generate_weapon() -> ItemData:
	var data = ItemData.new()
	data.item_type = ItemData.ItemType.Weapon
	
	var weapon_name = ""
	var weapon_type = weapon_types.pick_random()
	var weapon_description = descriptions.pick_random()
	var has_adjective:bool = (randf() > 0.5)
	if has_adjective:
		weapon_name = "The " + adjectives.pick_random() + " " + weapon_type
	else:
		weapon_name = "The " + weapon_type + " of " + weapon_description
	
	data.item_name = weapon_name
	
	data.attack = RandomUtils.generate_in_range(attack_range.x, attack_range.y, attack_deviation)
	data.power = RandomUtils.generate_in_range(power_range.x, power_range.y, power_deviation)
	data.defense = RandomUtils.generate_in_range(defense_range.x, defense_range.y, defense_deviation)
	data.hp = RandomUtils.generate_in_range(hp_range.x, hp_range.y, hp_deviation)
	
	data.item_portrait = weapon_portraits.pick_random()
	
	return data

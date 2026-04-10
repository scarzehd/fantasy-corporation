extends Resource
class_name CharacterData

enum CharacterClass {
	Fighter,
	Mage,
	Bard
}

# I separated these out because I thought we might be short on space in the combat section.
# In that case, we could show only the first name.
@export var first_name:String = "John"
@export var last_name:String = "Smith"

@export var attack:int = 10
@export var power:int = 100
@export var defense:int = 50
@export var hp:int = 100
@export var portrait:Texture2D
@export var character_class:CharacterClass

@export var items:Dictionary[ItemData.ItemSlot, ItemData]

@export var head:Texture2D

var full_name:String :
	get():
		return first_name + " " + last_name

static func get_class_name(char_class:CharacterClass) -> String:
	match char_class:
		CharacterClass.Fighter:
			return "Fighter"
		CharacterClass.Mage:
			return "Mage"
		CharacterClass.Bard:
			return "Bard"
	
	return ""

func get_character_class_name() -> String:
	return get_class_name(character_class)

func get_modified_hp() -> int:
	var total = hp
	
	for item in items.values():
		total += item.hp
	
	return total

func get_modified_power() -> int:
	var total = power
	
	for item in items.values():
		total += item.power
	
	return total

func get_modified_attack() -> int:
	var total = attack
	
	for item in items.values():
		total += item.attack
	
	return total

func get_modified_defense() -> int:
	var total = defense
	
	for item in items.values():
		total += item.defense
	
	return total

func unequip_item(item_data:ItemData):
	for key in items.keys():
		if items[key] == item_data:
			items.erase(key)
	
	item_data.equipped_by = null

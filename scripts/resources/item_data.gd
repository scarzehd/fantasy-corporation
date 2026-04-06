extends Resource
class_name ItemData

enum ItemType {
	Weapon,
	Armor
}

enum ItemSlot {
	Weapon,
	Armor1,
	Armor2
}

static func get_slot_name(slot:ItemSlot) -> String:
	match slot:
		ItemSlot.Weapon:
			return "Weapon"
		ItemSlot.Armor1:
			return "Armor 1"
		ItemSlot.Armor2:
			return "Armor 2"
	
	return ""

static func get_type_for_slot(slot:ItemSlot) -> ItemType:
	match slot:
		ItemSlot.Weapon:
			return ItemType.Weapon
		ItemSlot.Armor1:
			return ItemType.Armor
		ItemSlot.Armor2:
			return ItemType.Armor
	
	return ItemType.Weapon

@export var item_name:String = "The Throngler"
@export var item_type:ItemType = ItemType.Weapon
@export var item_portrait:Texture2D

@export var attack:int = 0
@export var power:int = 0
@export var defense:int = 0
@export var hp:int = 0

@export var equipped_by:CharacterData

@export var purchase_price:int

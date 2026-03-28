extends Resource
class_name ItemData

enum ItemType {
	Weapon,
	Armor
}

@export var item_name:String = "The Throngler"
@export var item_type:ItemType = ItemType.Weapon
@export var item_portrait:Texture2D

@export var attack:int = 0
@export var power:int = 0
@export var defense:int = 0
@export var hp:int = 0

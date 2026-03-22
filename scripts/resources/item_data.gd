extends Resource
class_name ItemData

enum ItemType {
	Weapon,
	Armor
}

var item_name:String = "The Throngler"
var item_type:ItemType = ItemType.Weapon
var item_portrait:Texture2D

var attack:int = 0
var power:int = 0
var defense:int = 0
var hp:int = 0

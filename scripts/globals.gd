extends Node

signal money_changed(old_money:int, new_money:int)

var character_generator:CharacterGenerator = preload("res://resources/character_generator/starting_generator.tres")

var hired_characters:Array[CharacterData]

var owned_items:Array[ItemData]

var money:int = 100 :
	set(new_money):
		money_changed.emit(money, new_money)
		money = new_money

func _ready() -> void:
	var weapon_generator:BasicItemGenerator = load("res://resources/item_generator/test_weapon_generator.tres")
	
	for i in range(10):
		owned_items.append(weapon_generator.generate_weapon())

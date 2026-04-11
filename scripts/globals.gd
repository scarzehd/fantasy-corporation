extends Node

const LIFE_INSURANCE_PRICE:int = 200

signal money_changed(old_money:int, new_money:int)
@warning_ignore("unused_signal")
signal character_hired(character:CharacterData)

var character_generator:CharacterGenerator = preload("res://resources/character_generator/starting_generator.tres")

var hired_characters:Array[CharacterData]

var owned_items:Array[ItemData]

var money:int = 1000 :
	set(new_money):
		var old_money = money
		money = new_money
		money_changed.emit(old_money, new_money)

const DEFAULT_RESALE_MODIFIER:float = 0.75
var resale_modifier:float = 0.75
var old_resale_modifier:float = 0.75

const DEFAULT_ITEM_PRICE_MODIFIER:float = 1.0
var item_price_modifier:float = 1.0
var old_item_price_modifier:float = 1.0

const DEFAULT_ADVENTURER_PRICE_MODIFIER:float = 1.0
var adventurer_price_modifier:float = 1.0
var old_adventurer_price_modifier:float = 1.0

var volatility:float = 0.25
var variability:int = 10
var inflation:float = 1.0

func reset():
	volatility = 0.25
	variability = 10
	inflation = 1
	money = 0
	TimeManager.successful_adventures = 0
	TimeManager.day_number = 0
	TimeManager.daily_expenses = 0
	
	for character in hired_characters:
		for item in character.items:
			character.unequip_item(character.items[item])
	
	hired_characters.clear()
	owned_items.clear()

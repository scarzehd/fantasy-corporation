extends Node

const LIFE_INSURANCE_PRICE:int = 200

signal money_changed(old_money:int, new_money:int)
@warning_ignore("unused_signal")
signal character_hired(character:CharacterData)

var character_generator:CharacterGenerator = load("uid://qbn7iru5xo40")

var hired_characters:Array[CharacterData]

var owned_items:Array[ItemData]

var money:int = 1500 :
	set(new_money):
		var old_money = money
		money = new_money
		money_changed.emit(old_money, new_money)

const DEFAULT_RESALE_MODIFIER:float = 0.9
var resale_modifier:float = 0.9
var old_resale_modifier:float = 0.9

const DEFAULT_ITEM_PRICE_MODIFIER:float = 1.0
var item_price_modifier:float = 1.0
var old_item_price_modifier:float = 1.0

const DEFAULT_ADVENTURER_PRICE_MODIFIER:float = 1.0
var adventurer_price_modifier:float = 1.0
var old_adventurer_price_modifier:float = 1.0

var item_appreciation:float = 1.05

var volatility:float = 0.25
var variability:int = 5
var inflation:float = 1.0

func reset():
	volatility = 0.25
	variability = 10
	inflation = 1
	money = 1500
	TimeManager.successful_adventures = 0
	TimeManager.day_number = 0
	TimeManager.daily_expenses = 100
	
	for character in hired_characters:
		for item in character.items:
			character.unequip_item(character.items[item])
	
	hired_characters.clear()
	owned_items.clear()

extends Letter
class_name NewspaperLetter

const SCENE:PackedScene = preload("uid://c8wytlhkw0oa4")

@export var item_price_label:Label
@export var item_resale_price_label:Label
@export var character_price_label:Label
@export var daily_expense_label:Label

func _ready() -> void:
	var item_price_change = Globals.item_price_modifier - Globals.old_item_price_modifier
	var item_price_string = "%.0f%%" % (item_price_change * 100)
	if item_price_change > 0:
		item_price_string = "+" + item_price_string
		item_price_label.label_settings.font_color = Color.RED
	elif item_price_change < 0:
		item_price_label.label_settings.font_color = Color.GREEN
	else:
		item_price_string = "No change"
	
	item_price_label.text = "Item Price: " + str(roundi(Globals.item_price_modifier * 100)) + "% (" + item_price_string + ")"
	
	var item_resale_price_change = Globals.resale_modifier - Globals.old_resale_modifier
	var item_resale_price_string = "%.0f%%" % (item_resale_price_change * 100)
	if item_resale_price_change > 0:
		item_resale_price_string = "+" + item_resale_price_string
		item_resale_price_label.label_settings.font_color = Color.GREEN
	elif item_resale_price_change < 0:
		item_resale_price_label.label_settings.font_color = Color.RED
	else:
		item_resale_price_string = "No change"
	
	item_resale_price_label.text = "Item Resale Price: " + str(roundi(Globals.resale_modifier * 100)) + "% (" + item_resale_price_string + ")"
	
	var character_price_change = Globals.adventurer_price_modifier - Globals.old_adventurer_price_modifier
	var character_price_string = "%.0f%%" % (character_price_change * 100)
	if character_price_change > 0:
		character_price_string = "+" + character_price_string
		character_price_label.label_settings.font_color = Color.RED
	elif character_price_change < 0:
		character_price_label.label_settings.font_color = Color.GREEN
	else:
		character_price_string = "No change"
	
	character_price_label.text = "Adventurer Price: " + str(roundi(Globals.adventurer_price_modifier * 100)) + "% (" + character_price_string + ")"
	
	if Globals.adventurer_price_modifier > Globals.old_adventurer_price_modifier:
		character_price_label.label_settings.font_color = Color.RED
	elif Globals.adventurer_price_modifier < Globals.old_adventurer_price_modifier:
		character_price_label.label_settings.font_color = Color.GREEN
	
	daily_expense_label.text = "Daily Expenses: %.0f" % TimeManager.daily_expenses
	
	#if Globals.item_price_modifier > Globals.old_item_price_modifier:
		#item_price_label.label_settings.font_color = Color.RED
	#elif Globals.item_price_modifier < Globals.old_item_price_modifier:
		#item_price_label.label_settings.font_color = Color.GREEN
	#
	#if Globals.resale_modifier > Globals.old_resale_modifier:
		#item_resale_price_label.label_settings.font_color = Color.GREEN
	#elif Globals.resale_modifier < Globals.old_resale_modifier:
		#item_resale_price_label.label_settings.font_color = Color.RED
	#

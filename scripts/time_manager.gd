extends Node

signal day_started
signal day_ended

var day_number:int = 0

var successful_adventures:int = 0

var daily_expenses:float = 100

func _ready() -> void:
	await get_tree().process_frame
	day_started.emit()

func advance_day(fade:bool = true):
	if fade:
		await Fade.fade_out().finished
	day_number += 1
	day_ended.emit()
	
	if (day_number) % 5 == 0:
		var percent_change = daily_expenses * 1.15
		var rounded = roundi(percent_change / 10.0) * 10
		if rounded < daily_expenses + 10:
			rounded += 10
		daily_expenses = rounded
	
	if day_number != 1:
		update_world_state()
	
	if fade:
		await Fade.fade_in().finished
	
	if day_number != 1:
		Globals.money -= ceili(daily_expenses)
		SoundManager.money_press_sound.play_random()
	
	day_started.emit()

func update_world_state():
	var random = randf() - 0.5
	var indices:Array = [0, 1]
	
	var modified_variability = floori(Globals.variability / 2.0)
	var item_appreciation_change = randi_range(modified_variability, -modified_variability) * 0.05
	Globals.item_appreciation = clampf(1.05 + item_appreciation_change, 0.9, 1.5)
	
	while random <= Globals.volatility and indices.size() > 0:
		random = randf()
		indices.shuffle()
		
		var index = indices.pop_back()
		
		var current_value = get_state_value(index)
		var change = RandomUtils.generate_in_range(-Globals.variability, Globals.variability) * 0.05
		if change == 0:
			change = 0.05
		
		set_state_value(current_value + change, index)
	
	for index in indices:
		set_state_value(get_state_value(index), index)
	
	for item in Globals.owned_items:
		item.purchase_price = clampi(roundi(item.purchase_price * Globals.item_appreciation), 10, 1000)

func successful_adventure():
	successful_adventures += 1
	Globals.inflation *= 1.2
	Globals.variability += 1
	Globals.volatility = min(Globals.volatility + 0.1, 0.75)

# This is a stupid solution that I hate.
func set_state_value(value:float, index:int):
	match index:
		0:
			Globals.old_item_price_modifier = Globals.item_price_modifier
			# Modify min and max values by inflation, rounding to the nearest 0.05
			var min_value = roundf((0.5 / 0.05) * Globals.inflation) * 0.05
			var max_value = roundf((3.0 / 0.05) * Globals.inflation) * 0.05
			Globals.item_price_modifier = clampf(value, min_value, max_value)
		#1:
			#Globals.old_resale_modifier = Globals.resale_modifier
			# Modify min and max values by inflation, rounding to the nearest 0.05
			#var min_value = roundf((0.5 / 0.05) * Globals.inflation) * 0.05
			#var max_value = roundf((2.0 / 0.05) * Globals.inflation) * 0.05
			#Globals.resale_modifier = clampf(value, 0.5, 1.0)
		1:
			Globals.old_adventurer_price_modifier = Globals.adventurer_price_modifier
			# Make inflation affect adventurer price less than item price
			var modified_inflation = ((Globals.inflation + 1) * 0.5) + 1
			# Modify min and max values by inflation, rounding to the nearest 0.05
			var min_value = roundf((0.5 / 0.05) * modified_inflation) * 0.05
			var max_value = roundf((2.0 / 0.05) * modified_inflation) * 0.05
			Globals.adventurer_price_modifier = clampf(value, min_value, max_value)

func get_state_value(index:int) -> float:
	match index:
		0:
			return Globals.item_price_modifier
		#1:
			#return Globals.resale_modifier
		1:
			return Globals.adventurer_price_modifier
	
	return 0

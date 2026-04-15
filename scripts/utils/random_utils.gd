class_name RandomUtils

static func generate_in_range(lower:int, upper:int, deviation_scale:float = 0.5) -> int:
	var value = lower - 1
	
	# Clamping this increases the odds of getting a minimum or maximum value significantly
	# when the deviation scale is greater than 0.5
	# Instead, we repeat until we get a valid value.
	while value < lower or value > upper:
		var mean = (upper + lower) / 2.0
		var deviation = (upper - mean) * deviation_scale
		
		value = randfn(mean, deviation)
	
	return value

static func roll_attack(defense:int, attack:int) -> bool:
	# I hate this.
	if Tutorial.phase <= 0:
		return (randi_range(0, defense) <= attack) or (randf() < 0.05)
	else:
		return true

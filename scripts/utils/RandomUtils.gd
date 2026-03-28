class_name RandomUtils

static func generate_in_range(lower:int, upper:int, deviation_scale:float = 0.5) -> int:
	var mean = (upper + lower) / 2.0
	var deviation = (upper - mean) * deviation_scale
	return clamp(roundi(randfn(mean, deviation)), lower, upper)

static func roll_attack(defense:int, attack:int) -> bool:
	return (randi_range(0, defense) <= attack) or (randf() < 0.05)

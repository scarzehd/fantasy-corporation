class_name RandomUtils

static func generate_in_range(lower:int, upper:int, deviation_scale:float = 0.5) -> int:
	var mean = (upper + lower) / 2.0
	var deviation = (upper - mean) * deviation_scale
	return clamp(roundi(randfn(mean, deviation)), lower, upper)

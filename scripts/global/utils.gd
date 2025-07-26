extends Node

var rng = RandomNumberGenerator.new()

func rand_with_chance(chance: float) -> bool:
	var r = rng.rand_weighted([chance, 1.0 - chance])
	return r == 0    

func rand_in_range(lower: int, upper: int) -> int:
	return rng.randi_range(lower, upper)

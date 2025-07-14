class_name Enemy extends Node2D

var enemy: GenericEnemy

func attack():
	await enemy.attack()

func highlight() -> void:
	await enemy.highlight()

func get_scale_to_fit(w: float, h: float) -> float:
	var size = enemy.get_area_size()
	return min(w / size.x, h / size.y)

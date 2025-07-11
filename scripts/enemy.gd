class_name Enemy extends Node2D

var enemy: GenericEnemy

func attack():
	await enemy.attack()

func highlight() -> void:
	var m = enemy.sprite.modulate
	enemy.sprite.modulate = Color.DARK_ORANGE
	await get_tree().create_timer(0.5).timeout
	enemy.sprite.modulate = m

func get_scale_to_fit(w: float, h: float) -> float:
	var size = enemy.get_area_size()
	return min(w / size.x, h / size.y)

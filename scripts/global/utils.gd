extends Node

var rng = RandomNumberGenerator.new()

func rand_with_chance(chance: float) -> bool:
	var r = rng.rand_weighted([chance, 1.0 - chance])
	return r == 0    

func rand_in_range(lower: int, upper: int) -> int:
	return rng.randi_range(lower, upper)

func resize_sprite_to_polygon(sprite: Sprite2D, polygon: Polygon2D) -> void:
	var min_x = polygon.polygon[0].x
	var max_x = polygon.polygon[0].x
	var min_y = polygon.polygon[0].y
	var max_y = polygon.polygon[0].y
	
	for pt in polygon.polygon:
		min_x = min(min_x, pt.x)
		max_x = max(max_x, pt.x)
		min_y = min(min_y, pt.y)
		max_y = max(max_y, pt.y)
	
	var W = max_x - min_x
	var H = max_y - min_y
	
	var s = min(W / sprite.texture.get_width(), H / sprite.texture.get_height())

	sprite.position = Vector2((min_x + max_x) / 2, (min_y + max_y) / 2)
	sprite.scale = Vector2(s, s)
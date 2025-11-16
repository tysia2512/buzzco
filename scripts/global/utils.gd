extends Node

var rng = RandomNumberGenerator.new()

func rand_with_chance(chance: float) -> bool:
	var r = rng.rand_weighted([chance, 1.0 - chance])
	return r == 0    

func rand_in_range(lower: int, upper: int) -> int:
	return rng.randi_range(lower, upper)

func resize_sprite_to_polygon(sprite: Sprite2D, polygon: Polygon2D) -> void:
	var size = get_size(polygon)
	var center = get_center(polygon)
	
	var s = min(size.x / sprite.texture.get_width(), size.y / sprite.texture.get_height())

	sprite.position = center
	sprite.scale = Vector2(s, s)

func get_size(p: Polygon2D) -> Vector2:
	var min_x = p.polygon[0].x
	var max_x = p.polygon[0].x
	var min_y = p.polygon[0].y
	var max_y = p.polygon[0].y

	for pt in p.polygon:
		min_x = min(min_x, pt.x)
		max_x = max(max_x, pt.x)
		min_y = min(min_y, pt.y)
		max_y = max(max_y, pt.y)
	
	var W = max_x - min_x
	var H = max_y - min_y

	return Vector2(W, H)

func get_center(p: Polygon2D) -> Vector2:
	var min_x = p.polygon[0].x
	var max_x = p.polygon[0].x
	var min_y = p.polygon[0].y
	var max_y = p.polygon[0].y

	for pt in p.polygon:
		min_x = min(min_x, pt.x)
		max_x = max(max_x, pt.x)
		min_y = min(min_y, pt.y)
		max_y = max(max_y, pt.y)
	
	var X = (max_x + min_x) / 2
	var Y = (max_y + min_y) / 2

	return Vector2(X, Y)
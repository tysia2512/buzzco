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

# Arranges the cards within the width around the center in a line
func arrange_cards(width: int, center: Vector2, cards: Array) -> void:
	if cards.is_empty():
		return
	var card_width = cards[0].card.get_texture_size().x
	var gap = card_width / 4
	var w = min(width, (len(cards) - 1) * card_width + (len(cards) - 1) * gap)
	
	var current_x = 0
	var delta_x = 0
	delta_x = w / (len(cards) - 1)
	for card in cards:
		var destination = Vector2(current_x - w / 2, 0) + center
		
		card.tween = card.create_tween()
		card.tween.tween_property(card, "position", destination, 0.3)
		
		current_x += delta_x

static func get_absolute_z_index(target: Node2D) -> int:
	var node = target;
	var z_index = 0;
	while node and node.is_class('Node2D'):
		z_index += node.z_index;
		if !node.z_as_relative:
			break;
		node = node.get_parent();
	return z_index;

enum CardOwnership {
	BOARD,
	HAND,
	PREVIEW
}

func _is_card_in_hand(card: TypedCard) -> bool:
	return card.card.is_in_hand()

func _is_card_on_board(card: TypedCard) -> bool:
	return card.card.is_on_the_board()

func _is_in_preview(card: TypedCard) -> bool:
	return card.card.is_in_dialog || card.card.is_in_shop

func _get_card_ownership(card: TypedCard) -> CardOwnership:
	if _is_card_in_hand(card):
		return CardOwnership.HAND
	elif _is_card_on_board(card):
		return CardOwnership.BOARD
	elif _is_in_preview(card):
		return CardOwnership.PREVIEW

	assert(false, "Card ownership could not be determined")
	return CardOwnership.PREVIEW

func _get_position_in_parent(node: Node2D) -> int:
	var parent = node.get_parent()
	if parent == null:
		return -1
	return parent.get_children().find(node)

func _sort_top_card(a: TypedCard, b: TypedCard) -> bool:
	var z_index_a = get_absolute_z_index(a)
	var z_index_b = get_absolute_z_index(b)
	if z_index_a != z_index_b:
		return z_index_a > z_index_b
	
	var ownership_a = _get_card_ownership(a)
	var ownership_b = _get_card_ownership(b)
	if ownership_a != ownership_b:
		return ownership_a > ownership_b

	if ownership_a == CardOwnership.HAND:
		return _get_position_in_parent(a) > _get_position_in_parent(b)
	elif ownership_a == CardOwnership.BOARD:
		var tile_a = a.card.get_grid_tile()
		var tile_b = b.card.get_grid_tile()
		return _get_position_in_parent(tile_a) > _get_position_in_parent(tile_b)
	elif ownership_a == CardOwnership.PREVIEW:
		return _get_position_in_parent(a) > _get_position_in_parent(b)

	return false

func get_front_card(cards: Array) -> TypedCard:
	if cards.is_empty():
		return null
	cards.sort_custom(_sort_top_card)
	return cards[0]
	

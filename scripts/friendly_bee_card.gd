class_name FriendlyBeeCard extends TypedCard

var _attack_value = 1

func _process(delta: float) -> void:
	if card.get_grid_tile() == null:
		return
	var cards = card.get_grid_tile().get_neighbors().map(
		func(tile): return tile.get_card()
		).filter(func(x): return x != null and x.card_class == GenericCard.CardClass.BEE)
	card.current_attack_points = _attack_value * (1 + cards.size())

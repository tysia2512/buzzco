class_name CardSpawnPoint extends Node2D

@onready var W: int = get_viewport().get_visible_rect().size.y * 0.6

func get_cards():
	return get_children().filter(func(x): return x is Card)

func _process(delta: float):
	_arrange_cards()

func _arrange_cards():
	var cards = get_cards()
	if cards.is_empty():
		return
	var card_width = cards[0].get_texture_size().x
	var gap = card_width / 4
	var w = min(W, cards.lenght() * card_width + (cards.lenght() - 1) * gap)
	
	var current_x = -w / 2 + card_width / 2
	for card in cards:
		card.position.x = current_x
		card.position.y = 0
		
		current_x += card_width + gap
	

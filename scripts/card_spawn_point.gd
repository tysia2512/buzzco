class_name CardSpawnPoint extends Node2D

@onready var W: int = get_viewport().get_visible_rect().size.y * 0.6

func get_cards():
	return get_children().filter(func(x): return x is TypedCard)

func _arrange_cards():
	var cards = get_cards()
	if cards.is_empty():
		return
	var card_width = cards[0].card.get_texture_size().x
	var gap = card_width / 4
	var w = min(W, (len(cards) - 1) * card_width + (len(cards) - 1) * gap)
	
	var current_x = 0
	var delta_x = 0
	if len(cards) > 0:
		delta_x = w / (len(cards) - 1)
	for card in cards:
		if !card.card.is_in_hand():
			continue
		var destination = Vector2(current_x - w / 2, 0)
		# if card.tween:
		# 	time_elapsed = card.tween.get_total_elapsed_time()
		card.tween = card.create_tween()
		card.tween.tween_property(card, "position", destination, 0.3)
		
		current_x += delta_x
	
func update():
	_arrange_cards()
	
func add_card(card: TypedCard):
	card.reparent(self)
	_arrange_cards()
	
func spawn_card(card: TypedCard, from: Vector2):
	add_child(card)
	var position_start = from - global_position
	card.position = position_start

	_arrange_cards()

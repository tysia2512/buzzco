class_name CardSpawnPoint extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
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
	var w = min(W, (len(cards) - 1) * card_width + (len(cards) - 1) * gap)
	
	var current_x = 0
	var delta_x = 0
	if len(cards) > 0:
		delta_x = w / (len(cards) - 1)
	for card in cards:
		if card.is_dragged:
			continue
		card.position.x = current_x - w / 2
		card.position.y = 0
		
		current_x += delta_x
	
func spawn_card():
	var card = card_scene.instantiate()
	card.visible = false
	add_child(card)
	_arrange_cards()
	card.visible = true

	

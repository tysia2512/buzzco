class_name Deck extends Node2D

@onready var hand_spawn_point: CardSpawnPoint = $"../CardSpawnPoint"
@onready var card_spawn_point: Node2D = $SpawnPoint
@onready var _card_count_label: Label = $CardCountLabel

var _deck = []

func _ready() -> void:
	for card_type in DeckState.current_deck:
		var count = DeckState.current_deck[card_type]
		var scene = CardIndex.card_scenes[card_type]
		for i in range(count):
			_deck.append(scene)

	_deck.shuffle()
	_update_label()

func _on_spawn_card_button_pressed() -> void:
	_deal_card()

func _deal_card():
	if _deck.size() > 0:
		var card_scene = _deck.pop_back()
		var card = card_scene.instantiate()

		await hand_spawn_point.spawn_card(card, card_spawn_point.global_position)
	_update_label()

func deal_cards(cnt: int):
	for i in range(cnt):
		_deal_card()

func get_cards_in_deck_count() -> int:
	return _deck.size()

func _update_label() -> void:
	_card_count_label.text = str(get_cards_in_deck_count())

func get_cards_in_hand_count() -> int:
	return hand_spawn_point.get_cards().size()

func get_all_cards() -> Array:
	var cards = []
	cards.append_array(_deck)
	return cards

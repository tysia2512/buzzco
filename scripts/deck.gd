class_name Deck extends Node2D

@onready var hand_spawn_point: CardSpawnPoint = $"../CardSpawnPoint"
@onready var card_spawn_point: Node2D = $SpawnPoint
@onready var _card_count_label: Label = $CardCountLabel

var _card_count = 0
var working_deck: Array = []

func _ready() -> void:
	CardEventBus.card_purchased.connect(_on_card_purchased)

func _on_spawn_card_button_pressed() -> void:
	_deal_card()

func load_deck() -> void:
	working_deck = DeckState.current_deck.duplicate()

	_card_count = working_deck.size()
	working_deck.shuffle()

	_update_label()

func _deal_card():
	#TODO: handle empty deck case
	assert(_card_count > 0)
	var card_details = working_deck.pop_back()
	_card_count = working_deck.size()
	#TODO: Add traits handling

	var card_scene = CardIndex.card_scenes[card_details.card_type]
	var card = card_scene.instantiate()
	await hand_spawn_point.spawn_card(card, card_spawn_point.global_position)

	_update_label()

func deal_cards(cnt: int):
	for i in range(cnt):
		_deal_card()

func _update_label() -> void:
	_card_count_label.text = str(_card_count)

func get_cards_in_hand_count() -> int:
	return hand_spawn_point.get_cards().size()

func get_all_cards() -> Array:
	return working_deck

func _on_card_purchased(card_details: CardDetails) -> void:
	DeckState.current_deck.append(card_details)

	working_deck.append(card_details)
	_card_count = working_deck.size()
	working_deck.shuffle()

func get_cards_in_deck_count():
	return _card_count
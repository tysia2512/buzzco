class_name Deck extends Node2D

@onready var hand_spawn_point: CardSpawnPoint = $"../CardSpawnPoint"
@onready var card_spawn_point: Node2D = $SpawnPoint
@onready var _card_count_label: Label = $CardCountLabel

var _card_count = 0
var working_deck: Dictionary = {}

# func _ready() -> void:

func _on_spawn_card_button_pressed() -> void:
	_deal_card()

func load_deck() -> void:
	print("Deck ready")
	working_deck = DeckState.current_deck.duplicate()

	_card_count = 0
	for card_type in working_deck:
		_card_count += working_deck[card_type]

	_update_label()

func _deal_card():
	print("Dealing card")
	#TODO: handle empty deck case
	assert(_card_count > 0)


	var card_index = Utils.rand_in_range(0, _card_count - 1)
	var cumulative_count = 0
	var selected_card_type = null

	for card_type in working_deck:
		cumulative_count += working_deck[card_type]
		if card_index < cumulative_count:
			selected_card_type = card_type
			working_deck[card_type] -= 1
			_card_count -= 1
			break
			
	var card_scene = CardIndex.card_scenes[selected_card_type]
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

func get_all_cards() -> Dictionary:
	return working_deck

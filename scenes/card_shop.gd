extends Node2D

signal card_shop_closed

@onready var deck_preview_card_scene = preload("res://scenes/deck_preview_card.tscn")
@onready var _flow_container: FlowContainer = $HFlowContainer

var _cards_arranged: bool = false

var _cards = []

func _ready() -> void:
	z_index = ZLayers.DECK_DISPLAY

func load() -> void:
	_clear()
	var card_types = _get_random_cards()
	for card_type in card_types:
		var card_scene = CardIndex.card_scenes[card_type]
		var panel = Panel.new()
		var card = card_scene.instantiate() as TypedCard
		card.visible = false
		add_child(card)
		_cards.append(card)
		card.card.set_card_in_display_mode()
		card.card.set_in_hand(false)
		card.card.is_in_shop = true
		card.card_selected.connect(_select_card)
		_flow_container.add_child(panel)

		panel.custom_minimum_size = card.card.get_texture_size()

func _process(delta: float) -> void:
	if _cards_arranged:
		return

	assert(_flow_container.get_child_count() == _cards.size())
	var panels = _flow_container.get_children()
	for i in range(_flow_container.get_child_count()):
		var panel = panels[i]
		var card = _cards[i]
		card.position = panel.global_position - position + card.card.get_texture_size() / 2
		card.visible = true
	_cards_arranged = true
	_flow_container.visible = false


func _get_random_cards() -> Array:
	var available_card_types = CardIndex.CardType.values()
	available_card_types.shuffle()
	var selected_card_types = available_card_types.slice(0, 2)
	return selected_card_types

func _clear():
	_cards_arranged = false
	_flow_container.visible = true
	for child in _flow_container.get_children():
		child.queue_free()
	for card in _cards:
		card.queue_free()
	_cards.clear()

var _selected_card: TypedCard = null

func _select_card(card: TypedCard) -> void:
	if _selected_card != null:
		return
	await card.animate_selection()
	CardEventBus.card_purchased.emit(CardDetails.new(card.card_type, {}))
	card_shop_closed.emit()

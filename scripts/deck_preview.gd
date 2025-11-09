class_name DeckPreview extends Node2D

signal close_preview

@onready var deck_preview_card_scene = preload("res://scenes/deck_preview_card.tscn")

@onready var _flow_container: FlowContainer = $FlowContainer
@onready var _close_button: Button = $CloseButton

#TODO: put on a new top layer

var _processor: CardSelectionProcessor = null

var _cards_arranged: bool = false
func ready() -> void:
	z_index = ZLayers.DECK_DISPLAY

func load(deck: Deck, processor: CardSelectionProcessor) -> void:
	_clear()

	_processor = processor

	if processor != null and !processor.get_allow_skip_selection():
		_close_button.visible = false
	else:
		_close_button.visible = true

	var card_count = deck.get_all_cards()

	for card_type in CardIndex.card_scenes:
		if !card_count.has(card_type):
			continue
		if card_count[card_type] == null || card_count[card_type] == 0:
			continue
		var deck_preview_card = deck_preview_card_scene.instantiate() as DeckPreviewCard
		var card = CardIndex.card_scenes[card_type].instantiate() as TypedCard
		card.visible = false
		add_child(card)
		card.card.set_card_in_display_mode()
		card.card.is_in_dialog = true
		card.card.set_in_hand(false)
		if _processor != null:
			card.card_selected.connect(_select_card)

		_flow_container.add_child(deck_preview_card)

		deck_preview_card.panel.custom_minimum_size = card.card.get_texture_size()
		deck_preview_card.label.text = 'x' + str(card_count[card_type])
		deck_preview_card.card = card
		
func _process(delta: float) -> void:
	if _cards_arranged:
		return
	for child in _flow_container.get_children():
		var deck_preview_card = child as DeckPreviewCard
		deck_preview_card.card.position = deck_preview_card.panel.global_position - position + deck_preview_card.card.card.get_texture_size() / 2
		deck_preview_card.card.visible = true
	_cards_arranged = true
	_flow_container.visible = false

func _on_close_button_pressed() -> void:
	for child in _flow_container.get_children():
		child.queue_free()
	for child in get_children():
		if child is TypedCard:
			child.queue_free()
	close_preview.emit()

func _select_card(card: TypedCard) -> void:
	await _processor.process_card(card)
	close_preview.emit()

func _clear():
	_cards_arranged = false
	_flow_container.visible = true
	for child in _flow_container.get_children():
		child.queue_free()
	for child in get_children():
		if child is TypedCard:
			child.queue_free()

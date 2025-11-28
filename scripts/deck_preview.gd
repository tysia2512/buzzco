class_name DeckPreview extends Node2D

signal close_preview

@onready var deck_preview_card_scene = preload("res://scenes/deck_preview_card.tscn")

@onready var _close_button: Button = $CloseButton
@onready var _spawn_point: Node2D = $SpawnPoint
# TODO: we need multiple
@onready var _card_space: Polygon2D = $Polygon2D

# TODO: put on a new top layer

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

	var cards_in_deck = deck.get_all_cards()
	var cards = []
	for cd in cards_in_deck:
		assert(cd is CardDetails)
		var typed_card = TypedCardCreator.details_to_node(cd)
		cards.append(typed_card)
		add_child(typed_card)
		typed_card.position = _spawn_point.position
		typed_card.card.set_card_in_display_mode()
		typed_card.card.set_in_hand(false)
		if _processor != null:
			typed_card.card_selected.connect(_select_card)

	Utils.arrange_cards(
		_get_area_width(_card_space), 
		_get_area_center(_card_space), 
		cards)
	_cards_arranged = true
	ActionEventBus.open_overlay.emit()

func _get_area_width(p: Polygon2D):
	return Utils.get_size(p).x

func _get_area_center(p: Polygon2D):
	return Utils.get_center(p)

func _on_close_button_pressed() -> void:
	for child in get_children():
		if child is TypedCard:
			child.queue_free()
	ActionEventBus.close_overlay.emit()
	close_preview.emit()

func _select_card(card: TypedCard) -> void:
	await _processor.process_card(card)
	ActionEventBus.close_overlay.emit()
	close_preview.emit()

func _clear():
	_cards_arranged = false
	for child in get_children():
		if child is TypedCard:
			child.queue_free()

func check_for_card() -> TypedCard:
	print("Checking for card")
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	print("Result: ", result)
	if result.is_empty():
		return null
	var card_area = result[0].collider
	print("Has a collider: ", card_area)
	assert(card_area is CardArea)
	var card = (card_area as CardArea).get_card()
	assert(card != null)
	assert(card is TypedCard)
	return card

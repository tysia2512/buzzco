class_name RemoveSelectedCardProcessor extends CardSelectionProcessor

func process_card(card: TypedCard) -> void:
	await card.animate_selection()
	#TODO: add card equality and select specific card
	#TODO keep the details in the card
	CardEventBus.card_removed_from_deck.emit(CardDetails.new(card.card_type, {}))
	ActionEventBus.perform_player_action.emit()

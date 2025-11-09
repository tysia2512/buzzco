class_name RemoveSelectedCardProcessor extends CardSelectionProcessor

func process_card(card: TypedCard) -> void:
	await card.animate_selection()
	#TODO: add card equality and select specific card
	DeckState.current_deck[card.card_type] -= 1

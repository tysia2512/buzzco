extends OnCardPlaced

@onready var _processor = $"../RemoveSelectedCardProcessor"

func on_card_placed(_tile: GridTile) -> void:
	CardEventBus.select_card_from_deck.emit(_processor)
	
	

extends OnCardPlaced

@onready var _processor = $"../RemoveSelectedCardProcessor"

func on_card_placed(tile: GridTile) -> void:
	print("Secret Police Bee placed on tile: ", tile)
	CardEventBus.select_card_from_deck.emit(_processor)
	
	

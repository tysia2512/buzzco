class_name SecretPoliceBeeCard extends TypedCard

@onready var _card_processor: RemoveSelectedCardProcessor = $RemoveSelectedCardProcessor

func _ready():
	card = $Card

func _on_card_card_placed(tile: GridTile) -> void:
	print("Secret Police Bee placed on tile: ", tile)
	CardEventBus.select_card_from_deck.emit(_card_processor)

extends Node

func _ready() -> void:
	var _random_card = CardDetails.generate_random_card()
	print("Random card generated for testing: ", _random_card)
	print("Random card type: ", _random_card.card_type)
	print("Random card traits: ", _random_card.traits)

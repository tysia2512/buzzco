extends Node

var _starter_deck_counts: Dictionary = {
	CardIndex.CardType.BASIC_BEE: 1,
	CardIndex.CardType.FRIENDLY_BEE: 1,
	CardIndex.CardType.SECOND_STINGER: 1,
	CardIndex.CardType.CHARGER_BEE: 1,
	CardIndex.CardType.PROTECTOR_BEE: 1,
	CardIndex.CardType.DRILL_OPERATOR_BEE: 1,
	CardIndex.CardType.SECRET_POLICE_BEE: 20
}

var current_deck: Array = []

var starter_deck: Array = get_starter_deck()

func get_starter_deck() -> Array:
	var deck: Array = []
	for card_type in _starter_deck_counts:
		var count = _starter_deck_counts[card_type]
		for i in range(count):
			var card = CardDetails.new(card_type, {CardIndex.CardTrait.DOUBLE_ATTACK: false})
			deck.append(card)
	return deck

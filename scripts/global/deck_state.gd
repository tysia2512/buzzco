extends Node

var starter_deck: Dictionary = {
	CardIndex.CardType.BASIC_BEE: 8,
	CardIndex.CardType.FRIENDLY_BEE: 2,
	CardIndex.CardType.SECOND_STINGER: 2,
	CardIndex.CardType.CHARGER_BEE: 3,
	CardIndex.CardType.PROTECTOR_BEE: 5,
	CardIndex.CardType.DRILL_OPERATOR_BEE: 1,
	CardIndex.CardType.SECRET_POLICE_BEE: 1
}

var current_deck: Dictionary = {}

var alternative_deck = [CardDetails.new(CardIndex.CardType.BASIC_BEE, {})]

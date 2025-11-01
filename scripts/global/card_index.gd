extends Node

enum CardType {
	BASIC_BEE,
	FRIENDLY_BEE,
	SECOND_STINGER,
	CHARGER_BEE,
	PROTECTOR_BEE
}

var card_scenes: Dictionary = {
	CardType.BASIC_BEE: preload("res://scenes/basic_bee_card.tscn"),
	CardType.FRIENDLY_BEE: preload("res://scenes/friendly_bee_card.tscn"),
	CardType.SECOND_STINGER: preload("res://scenes/second_stinger_card.tscn"),
	CardType.CHARGER_BEE: preload("res://scenes/charger_bee_card.tscn"),
	CardType.PROTECTOR_BEE: preload("res://scenes/protector_bee_card.tscn")
}

var starter_deck: Dictionary = {
	CardType.BASIC_BEE: 10,
	CardType.FRIENDLY_BEE: 6,
	CardType.SECOND_STINGER: 4,
	CardType.CHARGER_BEE: 4,
	CardType.PROTECTOR_BEE: 5
}
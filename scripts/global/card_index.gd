extends Node

enum CardType {
	BASIC_BEE,
	FRIENDLY_BEE,
	SECOND_STINGER,
	CHARGER_BEE,
	PROTECTOR_BEE,
	DRILL_OPERATOR_BEE,
	SECRET_POLICE_BEE
}

var card_scenes: Dictionary = {
	CardType.BASIC_BEE: preload("res://scenes/basic_bee_card.tscn"),
	CardType.FRIENDLY_BEE: preload("res://scenes/friendly_bee_card.tscn"),
	CardType.SECOND_STINGER: preload("res://scenes/second_stinger_card.tscn"),
	CardType.CHARGER_BEE: preload("res://scenes/charger_bee_card.tscn"),
	CardType.PROTECTOR_BEE: preload("res://scenes/protector_bee_card.tscn"),
	CardType.DRILL_OPERATOR_BEE: preload("res://scenes/drill_operator_bee_card.tscn"),
	CardType.SECRET_POLICE_BEE: preload("res://scenes/secret_police_bee_card.tscn")
}

enum CardTrait {
	DOUBLE_ATTACK
}

var trait_chances: Dictionary = {
	CardTrait.DOUBLE_ATTACK: 0.1
}
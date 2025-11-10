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

var _card_type_chance: Dictionary = {
	CardType.BASIC_BEE: 1,
	CardType.FRIENDLY_BEE: 1,
	CardType.SECOND_STINGER: 1,
	CardType.CHARGER_BEE: 1,
	CardType.PROTECTOR_BEE: 1,
	CardType.DRILL_OPERATOR_BEE: 1,
	CardType.SECRET_POLICE_BEE: 1
}

func get_random_card_type() -> CardType:
	var total_weight = 0
	for weight in _card_type_chance.values():
		total_weight += weight
	
	var random_value = Utils.rand_in_range(0, total_weight - 1)

	var cumulative_weight = 0
	for card_type in _card_type_chance:
		cumulative_weight += _card_type_chance[card_type]
		if random_value < cumulative_weight:
			return card_type
	
	assert(false, "Should not reach here")
	return CardType.BASIC_BEE  # Fallback

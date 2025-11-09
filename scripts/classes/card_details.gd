class_name CardDetails

var card_type: CardIndex.CardType

var traits: Dictionary = {}

func _init(type: CardIndex.CardType, traits_dict: Dictionary) -> void:
    card_type = type
    traits = traits_dict
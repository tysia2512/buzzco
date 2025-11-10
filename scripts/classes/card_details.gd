class_name CardDetails

var card_type: CardIndex.CardType

var traits: Dictionary = {}

func _init(type: CardIndex.CardType, traits_dict: Dictionary) -> void:
	card_type = type
	traits = traits_dict

static func generate_random_card():
	var card_type = CardIndex.get_random_card_type()
	
	var traits: Dictionary = {}
	for t in CardIndex.trait_chances:
		var chance = CardIndex.trait_chances[t]
		if Utils.rand_with_chance(chance):
			traits[t] = true
		else:
			traits[t] = false
	return CardDetails.new(card_type, traits)

func get_typed_card_node() -> TypedCard:
	var scene = CardIndex.card_scenes[card_type]
	var node = scene.instantiate()
	node.card_details = self
	return node


#TODO: add card details in typed card to be pulled and add init.
# Remember to use it in remove selected card processor and deck when spawning cards: in deck, shop, preview
#TODO: use this in deck_preview
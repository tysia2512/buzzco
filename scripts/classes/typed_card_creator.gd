class_name TypedCardCreator

static func details_to_node(card_details: CardDetails) -> TypedCard:
    var scene = CardIndex.card_scenes[card_details.card_type]
    var node = scene.instantiate()
    node.card_details = card_details
    return node

static func node_to_details(typed_card: TypedCard) -> CardDetails:
    return typed_card.card_details
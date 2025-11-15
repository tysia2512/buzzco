class_name TypedCardCreator

static func details_to_node(card_details: CardDetails) -> TypedCard:
    var scene = CardIndex.card_scenes[card_details.card_type]
    var node = scene.instantiate()
    return node

static func _initialize_traits(node: TypedCard, traits: Dictionary) -> void:
    print("Initialize traits")
    for t in traits:
        print("trait: ", t)
        assert(t is CardIndex.CardTrait)
        if traits[t]:
            var scene = CardIndex.trait_scenes[t]
            var t_scene = scene.instantiate()
            node.add_child(t_scene)

static func node_to_details(node: TypedCard) -> CardDetails:
    var type = node.card_type

    var ts = {}
    for t in node.get_trait_nodes():
        assert(t is Trait)
        ts[t.trait_type] = true

    return CardDetails.new(type, ts)
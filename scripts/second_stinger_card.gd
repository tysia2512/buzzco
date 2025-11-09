class_name SecondStingerCard extends TypedCard

@onready var effect_scene: PackedScene = preload("res://scenes/effect.tscn")

func _get_effects() -> Array[Node]:
	return get_children().filter(func(node): return node is Effect)

func _on_card_card_placed(_tile: GridTile) -> void:
	var top_tile = card.get_grid_tile().get_top_neighbor()
	if top_tile != null:
		var effect = effect_scene.instantiate() as Effect
		effect.multiplier = 2
		add_child(effect)
		effect.place(self, top_tile)

func _on_remove(_tile: GridTile) -> void:
	var effects = _get_effects()
	for effect in effects:
		effect.remove()
		effect.queue_free()

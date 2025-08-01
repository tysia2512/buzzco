class_name SecondStingerCard extends TypedCard

@onready var effect_scene: PackedScene = preload("res://scenes/effect.tscn")

const _attack_value = 0
const _name = "Second Stinger"

func _init():
	visible = false
	
func _get_effects() -> Array[Node]:
	return get_children().filter(func(node): return node is Effect)

func _ready():
	card = $Card
	card.attack_value = _attack_value
	card.card_name = _name
	visible = true
	
func _process(delta: float) -> void:
	card.current_attack_points = _attack_value

func _on_card_card_placed(tile: GridTile) -> void:
	var top_tile = card.get_grid_tile().get_top_neighbor()
	if top_tile != null:
		var effect = effect_scene.instantiate() as Effect
		effect.multiplier = 2
		add_child(effect)
		effect.place(self, top_tile)

func _on_remove(tile: GridTile) -> void:
	var effects = _get_effects()
	for effect in effects:
		effect.remove()
		effect.queue_free()

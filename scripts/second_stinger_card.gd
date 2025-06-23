class_name SecondStingerCard extends Node2D

@onready var effect_scene: PackedScene = preload("res://scenes/effect.tscn")
@onready var card: Card = $Card

const _attack_value = 0
const _name = "Second Stinger"

func _init():
	visible = false
	
func _get_effects() -> Array[Effect]:
	return get_children().filter(func(node): return node is Effect)

func _ready():
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
		effect.place(card, top_tile)

func _on_card_card_removed_from_board() -> void:
	var effects = _get_effects()
	for effect in effects:
		effect.remove()
		effect.queue_free()

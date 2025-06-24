class_name FriendlyBeeCard extends Node2D

@onready var card: Card = $Card

const _attack_value = 1
const _name = "Friendly Bee"

func _init() -> void:
	visible = false

func _ready():
	card.attack_value = _attack_value
	card.card_name = _name
	visible = true
	
func _process(delta: float) -> void:
	if card.get_grid_tile() == null:
		return
	var cards = card.get_grid_tile().get_neighbors().map(
		func(tile): return tile.get_card()
		).filter(func(x): return x != null)
	card.current_attack_points = _attack_value * (1 + cards.size())

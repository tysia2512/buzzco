class_name BasicBeeCard extends Node2D

@onready var card: Card = $Card

const _attack_value = 1
const _name = "Basic Bee"

func _init():
	visible = false

func _ready():
	card.attack_value = _attack_value
	card.card_name = _name
	print("we expect: ", _name, " but set: ", card.card_name)
	visible = true
	
func _process(delta: float) -> void:
	card.current_attack_points = _attack_value
	

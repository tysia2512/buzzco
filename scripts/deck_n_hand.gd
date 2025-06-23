class_name DeckNHand extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var card_spawn_point: CardSpawnPoint = $CardSpawnPoint

func _init():
	visible = false
	
func _ready():
	position.x = get_viewport().get_visible_rect().size.x / 2
	position.y = get_viewport().get_visible_rect().size.y * 3 / 4
	visible = true
	
func add_card(card: Card)-> void:
	card.set_in_hand()
	card.reparent(card_spawn_point)

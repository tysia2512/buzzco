class_name Deck extends Node2D

@onready var basic_bee_card_scene: PackedScene = preload("res://scenes/basic_bee_card.tscn")
@onready var friendly_bee_card_scene: PackedScene = preload("res://scenes/friendly_bee_card.tscn")
@onready var second_stinger_card_scene: PackedScene = preload("res://scenes/second_stinger_card.tscn")

@export var basic_bee_card_count: int = 4
@export var friendly_bee_card_count: int = 3
@export var second_stinger_card_count: int = 2

@onready var card_spawn_point: CardSpawnPoint = $"../CardSpawnPoint"

var _deck = []

func _ready() -> void:
	for i in range(0, basic_bee_card_count):
		_deck.append(basic_bee_card_scene)
	
	for i in range(0, friendly_bee_card_count):
		_deck.append(friendly_bee_card_scene)
		
	for i in range(0, second_stinger_card_count):
		_deck.append(second_stinger_card_scene)
		
	_deck.shuffle()

func _on_spawn_card_button_pressed() -> void:
	if _deck.size() > 0:
		var card_scene = _deck.pop_back()
		
		card_spawn_point.spawn_card(card_scene)

class_name Deck extends Node2D

@onready var basic_bee_card_scene: PackedScene = preload("res://scenes/basic_bee_card.tscn")
@onready var friendly_bee_card_scene: PackedScene = preload("res://scenes/friendly_bee_card.tscn")
@onready var second_stinger_card_scene: PackedScene = preload("res://scenes/second_stinger_card.tscn")

@export var basic_bee_card_count: int = 10
@export var friendly_bee_card_count: int = 6
@export var second_stinger_card_count: int = 4

@onready var hand_spawn_point: CardSpawnPoint = $"../CardSpawnPoint"
@onready var card_spawn_point: Node2D = $SpawnPoint
@onready var _card_count_label: Label = $CardCountLabel

var _deck = []

func _ready() -> void:
	for i in range(0, basic_bee_card_count):
		_deck.append(basic_bee_card_scene)
	
	for i in range(0, friendly_bee_card_count):
		_deck.append(friendly_bee_card_scene)
		
	for i in range(0, second_stinger_card_count):
		_deck.append(second_stinger_card_scene)
		
	_deck.shuffle()
	_update_label()

	print("GLOBAL position: ", global_position)

func _on_spawn_card_button_pressed() -> void:
	_deal_card()

func _deal_card():
	if _deck.size() > 0:
		var card_scene = _deck.pop_back()
		var card = card_scene.instantiate()

		await hand_spawn_point.spawn_card(card, card_spawn_point.global_position)
	_update_label()

func deal_cards(cnt: int):
	for i in range(cnt):
		_deal_card()

func get_cards_in_deck_count() -> int:
	return _deck.size()

func _update_label() -> void:
	_card_count_label.text = str(get_cards_in_deck_count())

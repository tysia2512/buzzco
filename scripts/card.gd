class_name Card extends Node2D

@export var attack_value: int = 1

@onready var attack_label: Label = $AttackLabel
@onready var base_card_sprite: Sprite2D = $BaseCardSprite

@export var is_dragged = false
@export var is_in_hand = true
@export var is_on_the_board = false

func _ready():
	attack_label.text = str(attack_value)

func get_texture_size():
	return base_card_sprite.scale * base_card_sprite.texture.get_size()

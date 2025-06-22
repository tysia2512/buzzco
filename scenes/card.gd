class_name Card extends Node2D

@export var attack_value: int = 1

@onready var attack_label: Label = $AttackLabel
@onready var base_card_sprite: Sprite2D = $BaseCardSprite

func _ready():
	attack_label.text = str(attack_value)

func get_texture_size():
	return base_card_sprite.get_texture_size()

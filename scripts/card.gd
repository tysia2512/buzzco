class_name Card extends Node2D

@export var attack_value: int = 1

@onready var attack_label: Label = $AttackLabel
@onready var base_card_sprite: Sprite2D = $BaseCardSprite

var _is_dragged = false
var _is_in_hand = true
var _is_on_the_board = false
var _tile_placed: GridTile = null

func _ready():
	attack_label.text = str(attack_value)

func get_texture_size():
	return base_card_sprite.scale * base_card_sprite.texture.get_size()

func set_is_dragged():
	_is_dragged = true
	_is_in_hand = false
	_is_on_the_board = false
	_tile_placed = null

func set_in_hand():
	_is_dragged = false
	_is_in_hand = true
	_is_on_the_board = false
	_tile_placed = null
	
func set_on_the_board(tile: GridTile):
	_is_dragged = false
	_is_in_hand = false
	_is_on_the_board = true
	_tile_placed = tile

func is_in_hand() -> bool:
	return _is_in_hand

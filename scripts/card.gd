class_name Card extends Node2D

@export var attack_value: int = 1
@export var card_name: String = "Card"
@export var current_attack_points: int = 1

@onready var name_label: Label = $NameLabel
@onready var attack_label: Label = $AttackLabel
@onready var base_card_sprite: Sprite2D = $BaseCardSprite
@onready var debug_attack_strength_label: Label = $DebugAttackStrengthLabel

var _is_dragged = false
var _is_in_hand = true
var _is_on_the_board = false
var _tile_placed: GridTile = null

func _init() -> void:
	visible = false

func _ready():
	_update_labels()
	visible = true

func _update_labels():
	attack_label.set_text(str(attack_value))
	name_label.set_text(card_name)
	debug_attack_strength_label.set_text(str(current_attack_points))

func _process(delta: float) -> void:
	#print("process card with name: ", card_name)
	_update_labels()
	
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
	
func get_grid_tile() -> GridTile:
	return _tile_placed

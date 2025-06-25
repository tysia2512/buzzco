class_name GenericCard extends Node2D

signal card_placed
signal card_removed_from_board

@export var attack_value: int = 1
@export var card_name: String = "Card"
@export var current_attack_points: int = 1
@export var pollen_cost: int = 2

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
	debug_attack_strength_label.set_text(str(get_attack_with_effects()))

func _process(delta: float) -> void:
	#print("process card with name: ", card_name)
	_update_labels()
	
func get_texture_size():
	return base_card_sprite.scale * base_card_sprite.texture.get_size()

func set_is_dragged():
	_is_dragged = true
	_is_in_hand = false
	_is_on_the_board = false
	if _tile_placed != null:
		_tile_placed.remove_card()
		_tile_placed = null

func set_in_hand():
	_is_dragged = false
	_is_in_hand = true
	_is_on_the_board = false
	if _tile_placed != null:
		emit_signal("card_removed_from_board", _tile_placed)
		_tile_placed.remove_card()
		_tile_placed = null
	
func set_on_the_board(tile: GridTile):
	_is_dragged = false
	_is_in_hand = false
	_is_on_the_board = true
	if !PollenManager.can_afford_pollen(pollen_cost):
		set_in_hand()
		return
	
	if _tile_placed != null:
		emit_signal("card_removed_from_board", _tile_placed)
		_tile_placed.remove_card()
	_tile_placed = tile
	PollenManager.pay_pollen(pollen_cost)
	emit_signal("card_placed", tile)

func is_in_hand() -> bool:
	return _is_in_hand

func is_on_the_board() -> bool:
	return _is_on_the_board
	
func get_grid_tile() -> GridTile:
	return _tile_placed

func get_attack_with_effects() -> int:
	if _tile_placed == null:
		return 0
		
	if _tile_placed.get_effects().is_empty():
		return current_attack_points
	
	var total = current_attack_points
	for effect in _tile_placed.get_effects():
		total = (effect as Effect).apply(total)
	return total
	
	

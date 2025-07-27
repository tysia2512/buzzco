class_name GenericCard extends Node2D

signal card_placed
signal card_removed_from_board

@export var attack_value: int = 1:
	set(value):
		attack_value = value
		if card_display:
			card_display.attack = value
		if attack_label:
			attack_label.set_text(str(attack_value))

@export var card_name: String = "Card":
	set(value):
		card_name = value
		if card_display:
			card_display.card_name = value
		if name_label:
			name_label.set_text(value)

@export var description: String = "Card Description":
	set(value):
		description = value
		if card_display:
			card_display.description = value

@export var current_attack_points: int = 1
@export var pollen_cost: int = 2
@export var texture: Texture2D:
	set(value):
		texture = value
		if tile_sprite:
			tile_sprite.init_texture(value)
		if card_display:
			card_display.texture = value

@onready var name_label: Label = $NameLabel
@onready var attack_label: Label = $AttackLabel
@onready var debug_attack_strength_label: Label = $DebugAttackStrengthLabel
@onready var tile_sprite: GridSprite2D = $GridSprite2D
@onready var card_display: CardDisplay = $CardDisplay
@onready var collision_polygon: CardCollisionPolygon = $Area2D/CollisionPolygon2D

var tween: Tween

enum CardDisplayMode {
	CARD,
	TILE,
	HOVER
}

var _card_display_mode: CardDisplayMode = CardDisplayMode.CARD:
	set(value):
		_card_display_mode = value
		_set_card_display_mode()

var _is_dragged = false:
	set(value):
		if value == _is_dragged:
			return

		_is_dragged = value
		_is_in_hand = false
		_is_on_the_board = false
		if value:
			_card_display_mode = CardDisplayMode.TILE

var _is_in_hand = true:
	set(value):
		if value == _is_in_hand:
			return
		_is_in_hand = value
		_is_dragged = false
		_is_on_the_board = false
		if value:
			_card_display_mode = CardDisplayMode.CARD

var _is_on_the_board = false:
	set(value):
		if value == _is_on_the_board:
			return

		_is_on_the_board = value
		_is_dragged = false
		_is_in_hand = false
		debug_attack_strength_label.visible = value
		if value:
			_card_display_mode = CardDisplayMode.TILE
		else:
			remove_from_the_board()

var _tile_placed: GridTile = null

func _ready():
	_card_display_mode = CardDisplayMode.CARD
	tile_sprite.init_texture(texture)
	card_display.texture = texture
	card_display.name = card_name
	card_display.description = description
	_update_labels()

func set_collision_shape_card(card: TypedCard):
	if collision_polygon:
		collision_polygon.card = card
	if card_display:
		card_display.card = card

func _update_labels():
	debug_attack_strength_label.set_text(str(get_attack_with_effects()))

func _set_tile_sprite_visible(v: bool) -> void:
	tile_sprite.visible = v
	attack_label.visible = v
	name_label.visible = v
	collision_polygon.disabled = !v

func _set_card_display_visible(v: bool) -> void:
	card_display.visible = v
	card_display.enable_collision = v

func _set_card_display_mode() -> void:
	print("THE SETTTER IS RUNNNING WIHT: ", _card_display_mode)
	_set_tile_sprite_visible(_card_display_mode == CardDisplayMode.TILE || _card_display_mode == CardDisplayMode.HOVER)
	if _card_display_mode == CardDisplayMode.HOVER:
		card_display.position = $HoverOffset.position
		card_display.z_index = 1
	else:
		card_display.position = Vector2.ZERO
		card_display.z_index = 0
	_set_card_display_visible(_card_display_mode == CardDisplayMode.CARD || _card_display_mode == CardDisplayMode.HOVER)
	
func get_texture_size():
	if _card_display_mode == CardDisplayMode.CARD:
		return card_display.get_texture_size()
	return tile_sprite.scale * tile_sprite.texture.get_size()

func set_is_dragged():
	if get_parent() and get_parent().tween:
		get_parent().tween.kill()
		
	_is_dragged = true

func set_in_hand():
	_is_in_hand = true
	
func set_on_the_board(tile: GridTile):
	assert(_tile_placed == null)
	if !PollenManager.can_afford_pollen(pollen_cost):
		set_in_hand()
		return

	_is_on_the_board = true
	_tile_placed = tile
	PollenManager.pay_pollen(pollen_cost)
	card_placed.emit(tile)

func remove_from_the_board():
	if _tile_placed != null:
		_tile_placed.remove_card()
		_tile_placed = null
		print("send card_removed_from_board")
		card_removed_from_board.emit(_tile_placed)

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
	
func _on_area_2d_mouse_entered() -> void:
	if !_is_on_the_board:
		return
	_card_display_mode = CardDisplayMode.HOVER

func _on_area_2d_mouse_exited() -> void:
	if _card_display_mode != CardDisplayMode.HOVER:
		return

	if _is_on_the_board:
		_card_display_mode = CardDisplayMode.TILE
	else:
		_card_display_mode = CardDisplayMode.CARD

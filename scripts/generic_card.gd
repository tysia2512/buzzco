class_name GenericCard extends Node2D

signal card_placed
signal card_removed_from_board
signal player_turn_start
signal card_selected_for_attack
signal card_selected
signal display_changed

enum CardClass {
	BEE,
	MOD
}

@export var card_class: CardClass = CardClass.BEE

@export var attack_value: int = 1:
	set(value):
		attack_value = value
		current_attack_points = value
		if card_display:
			card_display.attack = value
		if attack_label:
			attack_label.set_text(str(attack_value))

@export var card_name: String:
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

var current_attack_points: int = 1
@export var pollen_cost: int = 2
@export var texture: Texture2D:
	set(value):
		texture = value
		if tile_sprite:
			tile_sprite.texture = value
		if card_display:
			card_display.texture = value

@onready var name_label: Label = $NameLabel
@onready var attack_label: Label = $AttackLabel
@onready var tile_sprite: GridSprite2D = $GridSprite2D
@onready var card_display: CardDisplay = $CardDisplay
@onready var collision_polygon: CardCollisionPolygon = $Area2D/CollisionPolygon2D

var tween: Tween

enum CardDisplayMode {
	CARD,
	TILE,
	HOVER, # Hovered over on the board
	CARD_IN_FRONT # In hand and hovered over
}
var is_in_shop = false
var is_in_dialog = false

var _is_selected_for_attack = false

func set_card_in_display_mode() -> void:
	is_in_dialog = true
	_card_display_mode = CardDisplayMode.CARD
	card_display.z_index = ZLayers.DECK_DISPLAY

var _card_display_mode: CardDisplayMode = CardDisplayMode.CARD:
	set(value):
		_card_display_mode = value

		_set_tile_sprite_visible(_card_display_mode == CardDisplayMode.TILE || _card_display_mode == CardDisplayMode.HOVER)
		
		if _card_display_mode == CardDisplayMode.HOVER:
			card_display.position = $HoverOffset.position
			card_display.z_index = ZLayers.ON_HOVER
		elif _card_display_mode == CardDisplayMode.CARD_IN_FRONT:
			card_display.z_index = ZLayers.ON_HOVER
		else:
			card_display.position = Vector2.ZERO
			card_display.z_index = z_index

		_set_card_display_visible(
			_card_display_mode == CardDisplayMode.CARD || _card_display_mode == CardDisplayMode.HOVER 
			|| _card_display_mode == CardDisplayMode.CARD_IN_FRONT)
		
		display_changed.emit()

var _is_dragged = false:
	set(value):
		if value == _is_dragged:
			return

		_is_dragged = value
		_is_in_hand = false
		_is_on_the_board = false
		if value:
			_card_display_mode = CardDisplayMode.TILE
			z_index = ZLayers.ON_HOVER


var _is_in_hand = true:
	set(value):
		if value == _is_in_hand:
			return
		_is_in_hand = value
		_is_dragged = false
		_is_on_the_board = false
		if value:
			_card_display_mode = CardDisplayMode.CARD
			z_index = ZLayers.DEFAULT

var _is_on_the_board = false:
	set(value):
		if value == _is_on_the_board:
			return

		_is_on_the_board = value
		_is_dragged = false
		_is_in_hand = false
		set_process(value)
		if value:
			_card_display_mode = CardDisplayMode.TILE
			z_index = ZLayers.CARDS_ON_GRID
		else:
			remove_from_the_board()

var _tile_placed: GridTile = null

var _sprite_modulate: Color

func _ready():
	_sprite_modulate = tile_sprite.modulate
	_card_display_mode = CardDisplayMode.CARD
	tile_sprite.texture = texture
	card_display.texture = texture
	card_display.card_name = card_name
	card_display.description = description
	_update_labels()
	assert(z_index == ZLayers.DEFAULT, "GenericCard: z_index should be DEFAULT on ready")


func _process(_delta: float) -> void:
	if !can_be_selected_for_attack():
		_is_selected_for_attack = false
	if _is_selected_for_attack:
		tile_sprite.modulate = Color.RED
	else:
		tile_sprite.modulate = _sprite_modulate
	_update_labels()

func set_collision_shape_card(card: TypedCard):
	if collision_polygon:
		collision_polygon.card = card
	if card_display:
		card_display.card = card

func _update_labels():
	tile_sprite.number_on_display = get_attack_with_effects()

func _set_tile_sprite_visible(v: bool) -> void:
	tile_sprite.visible = v
	attack_label.visible = v
	name_label.visible = v
	collision_polygon.disabled = !v

func _set_card_display_visible(v: bool) -> void:
	card_display.visible = v
	card_display.enable_collision = v

func get_texture_size():
	if _card_display_mode == CardDisplayMode.CARD:
		return card_display.get_texture_size()
	return tile_sprite.scale * tile_sprite.texture.get_size()

func set_is_dragged():
	if get_parent() and get_parent().tween:
		get_parent().tween.kill()
		
	_is_dragged = true

func set_in_hand(v: bool = true):
	_is_in_hand = v
	
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
		card_removed_from_board.emit(_tile_placed)

func process_player_turn_start():
	player_turn_start.emit()

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

func set_in_front(v: bool) -> void:
	if v:
		z_index = ZLayers.ON_HOVER
	else:
		z_index = ZLayers.DEFAULT

func select_for_attack():
	_is_selected_for_attack = !_is_selected_for_attack
	card_selected_for_attack.emit()

func select():
	card_selected.emit()
	
func can_be_selected_for_attack() -> bool:
	if !_is_on_the_board:
		return false
	if GameState.turn_stage != GameState.TurnStage.SPECIFIC_INPUT:
		return false
	if GameState.specific_input != GameState.SpecificInput.LAUNCH_ATTACK_BEE_SELECT and GameState.specific_input != GameState.SpecificInput.ENEMY_OR_BEE_SELECT:
		return false
	return true

func can_be_selected() -> bool:
	return can_be_selected_for_dialog() or can_be_selected_for_shop()

func can_be_selected_for_dialog() -> bool:
	return is_in_dialog and GameState.turn_stage == GameState.TurnStage.SPECIFIC_INPUT and GameState.specific_input == GameState.SpecificInput.DIALOG_CARD_SELECT

func can_be_selected_for_shop() -> bool:
	return is_in_shop and GameState.turn_stage == GameState.TurnStage.SPECIFIC_INPUT and GameState.specific_input == GameState.SpecificInput.DIALOG_CARD_SELECT

var _traits = []

func register_trait(t: Trait):
	_traits.append(t)
	card_display.add_trait(t)
	tile_sprite.add_trait(t)

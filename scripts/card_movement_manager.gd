class_name CardMovementManager extends Node2D

signal card_placed

@onready var grid: Grid = $Grid
@onready var deck_n_hand: DeckNHand = $DeckNHand

var dragged_card: TypedCard = null
var _card_in_front: TypedCard = null
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if dragged_card:
		var p = get_global_mouse_position()
		dragged_card.position = Vector2(clamp(p.x, 0, screen_size.x), clamp(p.y, 0, screen_size.y))

func _unhandled_input(event: InputEvent) -> void:
	if GameState.turn_stage != GameState.TurnStage.PLAYER_MOVE and GameState.turn_stage != GameState.TurnStage.SPECIFIC_INPUT:
		return

	_handle_click(event)

	_handle_hover(event)

func _handle_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var clicked_card = check_for_card() as TypedCard
			if clicked_card == null:
				return
			if clicked_card.card.is_in_hand() and GameState.turn_stage == GameState.TurnStage.PLAYER_MOVE:
				dragged_card = check_for_card()
				if dragged_card:
					InputStatus.is_card_dragged = true
					dragged_card.card.set_is_dragged()
					dragged_card.reparent(self)
					deck_n_hand.card_spawn_point.update()
					dragged_card.position += get_global_mouse_position() - dragged_card.global_position
			elif clicked_card.card.can_be_selected_for_attack() and GameState.turn_stage == GameState.TurnStage.SPECIFIC_INPUT:
				clicked_card.card.select_for_attack()
			elif clicked_card.card.can_be_selected() and GameState.turn_stage == GameState.TurnStage.SPECIFIC_INPUT:
				clicked_card.card.select()
		else:
			if dragged_card == null:
				return
			var grid_tile = _check_for_grid_tile(get_global_mouse_position())
			if grid_tile != null && _can_place_on_tile(grid_tile, dragged_card.card):
				place_card(grid_tile)
			else:
				drop_card()

func _handle_hover(event: InputEvent) -> void:
	if event is InputEventMouse and !event.is_pressed() and !InputStatus.is_card_dragged:
		var card = check_for_card()

		# Handle the currently hovered card
		if _card_in_front != null:
			if card == _card_in_front:
				return
			else:
				_card_in_front.card.set_in_front(false)
				_card_in_front = null

		# Handle the new hovered card
		if card == null:
			return

		_card_in_front = card
		_card_in_front.card.set_in_front(true)
			
func _can_place_on_tile(grid_tile: GridTile, card: GenericCard) -> bool:
	if !GameState.is_player_turn():
		return false
	if !PollenManager.can_afford_pollen(card.pollen_cost):
		return false

	if !grid_tile.is_free():
		return false

	var bottom_neighbor = grid_tile.get_bottom_neighbor()

	if bottom_neighbor == null:
		return true

	if bottom_neighbor.get_card() != null:
		return true

	if bottom_neighbor.boulder != null and bottom_neighbor.boulder.is_grounded():
		return true

	return false


func place_card(tile: GridTile):
	grid.place_card(dragged_card, tile)
	dragged_card = null
	InputStatus.is_card_dragged = false
	card_placed.emit()

func drop_card():
	deck_n_hand.add_card(dragged_card)
	dragged_card = null
	InputStatus.is_card_dragged = false

func check_for_card() -> TypedCard:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.is_empty():
		return null
	var cards = result.filter(func(r): return r.collider is CardArea).map(func(r): return (r.collider as CardArea).get_card())
	var cards_on_tiles = result.filter(
		func(r): return r.collider is Area2D and r.collider.get_parent() is GenericCard
		).map(
			func(r): return r.collider.get_parent().get_parent() as TypedCard
			)
	return Utils.get_front_card(cards + cards_on_tiles)

func _check_for_grid_tile(p: Vector2) -> GridTile:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = p
	parameters.collide_with_areas = true
	parameters.collision_mask = 2
	var result = space_state.intersect_point(parameters)
	if !result.is_empty() and result[0].collider.get_parent() is GridTile:
		return result[0].collider.get_parent()
	return null

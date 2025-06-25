extends Node2D

@onready var grid: Grid = $Grid
@onready var deck_n_hand: DeckNHand = $DeckNHand

var dragged_card: TypedCard = null
var offset: Vector2 = Vector2.ZERO
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if dragged_card:
		var position = get_global_mouse_position() + offset
		dragged_card.position = Vector2(clamp(position.x, 0, screen_size.x), clamp(position.y, 0, screen_size.y))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragged_card = check_for_card()
			if dragged_card:
				dragged_card.card.set_is_dragged()
				dragged_card.reparent(self)
				offset = dragged_card.position - get_global_mouse_position()
		else:
			if dragged_card == null:
				return
			var grid_tile = check_for_grid_tile(dragged_card.global_position)
			print("grid tile: ", grid_tile)
			if grid_tile != null && PollenManager.can_afford_pollen(dragged_card.card.pollen_cost):
				grid.place_card(dragged_card, grid_tile)
			else:
				deck_n_hand.add_card(dragged_card)
			
			dragged_card = null
			offset = Vector2.ZERO

func check_for_card() -> TypedCard:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.is_empty():
		return null
	if !result[0].collider.get_parent().get_parent() is TypedCard:
		return
	var typed_card = result[0].collider.get_parent().get_parent() as TypedCard
	if !typed_card.card.is_in_hand():
		return
	return typed_card
	
func check_for_grid_tile(position: Vector2) -> GridTile:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = position
	parameters.collide_with_areas = true
	parameters.collision_mask = 2
	var result = space_state.intersect_point(parameters)
	if !result.is_empty() and result[0].collider.get_parent() is GridTile:
		return result[0].collider.get_parent()
	return null

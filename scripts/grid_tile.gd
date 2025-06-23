class_name GridTile extends Node2D

@export var row: int = 0
@export var column: int = 0
@export var grid: Grid

@onready var sprite: Sprite2D = $Sprite2D
@onready var debug_coord_label: Label = $DebugCoordLabel

var _card: Card = null
var _effects = {}

func get_texture_size():
	return sprite.get_texture_size() 
	
func set_grid_position(_row: int, _column: int):
	row = _row
	column = _column
	debug_coord_label.set_text("X: " + str(row) + ", Y: " + str(column))

func get_coords():
	return Vector2(row, column)

func put_card(card: Card) -> void:
	_card = card
	
func remove_card():
	_card = null
	
func get_card() -> Card:
	return _card

func highlight() -> void:
	debug_coord_label.add_theme_color_override("font_color", Color.AQUAMARINE)

func get_top_neighbor() -> GridTile:
	return grid.get_tile(row - 2, column)

func add_effect(effect: Effect) -> void:
	_effects[effect] = true
	
func remove_effect(effect: Effect) -> void:
	_effects.erase(effect)
	
func get_effects() -> Array:
	return _effects.keys().map(func(key): return key as Effect)
	
func get_neighbors() -> Array: 
	var neighbors = [
		Vector2(row - 2, column), 
		Vector2(row + 2, column),
		Vector2(row - 1, column), 
		Vector2(row + 1, column)]
	if row % 2 == 1:
		neighbors.append_array([
			Vector2(row - 1, column + 1), 
			Vector2(row + 1, column + 1)
		])
	else:
		neighbors.append_array([
			Vector2(row - 1, column - 1), 
			Vector2(row + 1, column - 1)
		])
	return neighbors.map(
		func(coord): return grid.get_tile(coord.x, coord.y)
		).filter(func(tile): return tile != null)
		

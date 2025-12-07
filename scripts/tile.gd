class_name Tile extends Node2D

@export var row: int = 0
@export var column: int = 0
@export var grid: Grid

@onready var debug_coord_label: Label = $DebugCoordLabel

func _ready():
	if GameState.DEBUG_MODE:
		debug_coord_label.visible = true
	else: 
		debug_coord_label.visible = false


func set_grid_position(_row: int, _column: int):
	row = _row
	column = _column
	debug_coord_label.set_text("X: " + str(row) + ", Y: " + str(column))

func get_coords():
	return Vector2(row, column)

func get_top_neighbor() -> GridTile:
	return grid.get_tile(row - 2, column)

func get_bottom_neighbor() -> GridTile:
	return grid.get_tile(row + 2, column)

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

func get_tiles_below() -> Array:
	var tiles_below = []
	var current_row = row + 2
	while current_row < grid.ROWS.size():
		var tile = grid.get_tile(current_row, column)
		if tile != null:
			tiles_below.append(tile)
		current_row += 2
	return tiles_below

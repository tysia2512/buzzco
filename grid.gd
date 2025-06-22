extends Node2D

@onready var GridTile = preload("res://scenes/grid_tile.tscn")

const FLIPPED = false
const ROWS = [4, 3, 4, 3, 4]
@onready var grid = []

func _ready():
	grid.resize(ROWS.size())
	for i in range(0, ROWS.size()):
		grid[i] = []
		grid[i].resize(ROWS[i])
		
	for i in range(0, ROWS.size()):
		for j in range(0, ROWS[i]):
			_add_grid_tile(i, j)
		
func _add_grid_tile(row: int, column: int):
	var tile = GridTile.instantiate()
	tile.visible = false
	add_child(tile)
	var h = tile.get_texture_size().y
	var w = tile.get_texture_size().x
	print("height: ", h, " width: ", w)
	
	var y = position.y + h * row / 2
	var x = position.x + column * w * 3 / 2
	if row % 2 == 1:
		x += w * 3 / 4
		
	tile.position.x = x
	tile.position.y = y
	grid[row][column] = tile
	tile.set_grid_position(row, column)
	tile.visible = true

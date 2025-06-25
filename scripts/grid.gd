class_name Grid extends Node2D

@onready var grid_tile = preload("res://scenes/grid_tile.tscn")
@onready var cards_node: Node2D = $Cards

const FLIPPED = false
const ROWS = [4, 3, 4, 3, 4, 3]
@onready var grid = []

func _ready():
	grid.resize(ROWS.size())
	for i in range(0, ROWS.size()):
		grid[i] = []
		grid[i].resize(ROWS[i])
		
	var tile = grid_tile.instantiate()
	tile.visible = false
	add_child(tile)
	var h = tile.get_texture_size().y
	var w = tile.get_texture_size().x
	tile.queue_free()
	var W = ROWS.max() * w + w/2
	var H = (h * ROWS.size() + 1) / 2
	
	for i in range(0, ROWS.size()):
		for j in range(0, ROWS[i]):
			_add_grid_tile(i, j, W / 2, H / 2)
		
func _add_grid_tile(row: int, column: int, offset_x: float, offset_y: float):
	var tile = grid_tile.instantiate()
	tile.visible = false
	add_child(tile)
	var h = tile.get_texture_size().y
	var w = tile.get_texture_size().x
	print("height: ", h, " width: ", w)
	
	var y = h * row / 2
	var x = column * w * 3 / 2
	if row % 2 == 1:
		x += w * 3 / 4
		
	tile.position.x = x - offset_x
	tile.position.y = y - offset_y
	grid[row][column] = tile
	tile.set_grid_position(row, column)
	tile.grid = self
	tile.visible = true

func place_card(card: TypedCard, grid_tile: GridTile) -> void:
	card.reparent(cards_node)
	card.card.set_on_the_board(grid_tile)
		
	grid_tile.put_card(card)
	card.position = grid_tile.position
	
func get_points() -> int:
	var points = 0
	for row in grid:
		for tile in row:
			if tile.get_card() != null:
				points += tile.get_card().card.get_attack_with_effects()
	return points

func clear_cards() -> void:
	for row in grid:
		for tile in row:
			if tile.get_card() != null:
				tile.remove_card()
	var children = cards_node.get_children()
	for child in children:
		cards_node.remove_child(child)

func get_tile(r: int, c: int) -> GridTile:
	if r < 0 || r >= grid.size():
		return null;
	if c < 0 || c >= grid[r].size():
		return null
	return grid[r][c]

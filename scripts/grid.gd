class_name Grid extends Node2D

@onready var enemy_tile = preload("res://scenes/enemy_tile.tscn")
@onready var grid_tile = preload("res://scenes/grid_tile.tscn")
@onready var cards_node: Node2D = $Cards

const FLIPPED = false
const ROWS = [4, 3, 4, 3, 4, 3, 4, 3]
@onready var grid = []
var tile_height
var tile_width
var H
var W

func _ready():
	grid.resize(ROWS.size())
	for i in range(0, ROWS.size()):
		grid[i] = []
		grid[i].resize(ROWS[i])
		
	var tile = grid_tile.instantiate()
	tile.visible = false
	add_child(tile)
	tile_height = tile.get_texture_size().y
	tile_width = tile.get_texture_size().x
	tile.queue_free()
	W = ROWS.max() * tile_width + tile_width / 2
	H = (tile_height * (ROWS.size() + 2) + 1) / 2
	
	for i in range(2, ROWS.size()):
		for j in range(0, ROWS[i]):
			_add_grid_tile(i, j)
		
func _add_grid_tile(row: int, column: int):
	var tile = grid_tile.instantiate()
	tile.visible = false
	add_child(tile)
		
	tile.position = get_coord(row, column)
	grid[row][column] = tile
	tile.set_grid_position(row, column)
	tile.grid = self
	tile.visible = true

func get_coord(row: int, column: int) -> Vector2:
	var x = column * tile_width * 3 / 2 - W / 2
	if row % 2 == 1:
		x += tile_width * 3 / 4
	var y = tile_height * row / 2 - H / 2
	
	return Vector2(x, y)

func place_card(card: TypedCard, grid_tile: GridTile) -> void:
	card.reparent(cards_node)
	card.card.set_on_the_board(grid_tile)
		
	grid_tile.put_card(card)
	card.position = grid_tile.position
	
func get_points() -> int:
	var points = 0
	for row in grid:
		for tile in row:
			if !(tile is GridTile):
				continue
			if tile.get_card() != null:
				points += tile.get_card().card.get_attack_with_effects()
	return points

func clear_cards() -> void:
	for row in grid:
		for tile in row:
			if !(tile is GridTile):
				continue
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

func generate_enemies(enemy_tile_generator: EnemyTileGenerator, enemy_manager: EnemyManager) -> void:
	var enemies = []

	for row in [0, 1]:
		for i in range(0, ROWS[row]):
			var tile = enemy_tile.instantiate() as EnemyTile
			tile.visible = false
			var enemy = enemy_tile_generator.generate_enemy() as Enemy
			enemies.append(enemy)
			add_child(tile)
			tile.set_enemy(enemy)
			tile.position = get_coord(row, i)
			var best_scale = enemy.get_scale_to_fit(tile_width, tile_height)
			tile.scale = Vector2(best_scale, best_scale)
			tile.set_grid_position(row, i)
			tile.visible = true
			
	enemies.sort_custom(func(e): return (e as Enemy).position.x)
	enemy_manager.set_enemies(enemies)

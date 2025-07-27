class_name Grid extends Node2D

@onready var enemy_tile = preload("res://scenes/enemy_tile.tscn")
@onready var grid_tile = preload("res://scenes/grid_tile.tscn")
@onready var boulder_scene = preload("res://scenes/boulder.tscn")
@onready var cards_node: Node2D = $Cards

signal boulder_move_finished

const FLIPPED = false
const ROWS = [4, 3, 4, 3, 4, 3, 4, 3]
@onready var grid = []
var tile_height
var tile_width
var H
var W

func _ready():
	set_up_new_grid()

func set_up_new_grid():
	grid.resize(ROWS.size())
	for i in range(0, ROWS.size()):
		grid[i] = []
		grid[i].resize(ROWS[i])
		
	var size_tile = grid_tile.instantiate()
	size_tile.visible = false
	add_child(size_tile)
	tile_height = size_tile.get_texture_size().y
	tile_width = size_tile.get_texture_size().x
	size_tile.queue_free()
	
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

func cards_on_board_count() -> int:
	var count = 0
	for row in grid:
		for tile in row:
			if !(tile is GridTile):
				continue
			if tile.get_card() != null:
				count += 1
	return count
	
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

	var enemy_scenes = enemy_tile_generator.generate_enemies([ROWS[0], ROWS[1]])

	for row in [0, 1]:
		for i in range(0, ROWS[row]):
			var tile = enemy_tile.instantiate() as EnemyTile
			tile.grid = self
			tile.row = row
			tile.column = i
			tile.visible = false
			var enemy_scene = enemy_scenes[row][i] as PackedScene
			if enemy_scene == null:
				continue
				
			var enemy = enemy_scene.instantiate() as Enemy
			enemies.append(enemy)
			add_child(tile)
			tile.set_enemy(enemy)
			tile.position = get_coord(row, i)
			tile.set_grid_position(row, i)
			tile.visible = true
			
	enemies.sort_custom(func(e): return (e as Enemy).position.x)
	enemy_manager.set_enemies(enemies)

func spawn_boulder(on_tile: GridTile):
	var boulder = boulder_scene.instantiate() as Boulder
	if on_tile.boulder != null:
		return

	_clear_for_boulder(on_tile)
	
	on_tile.boulder = boulder
	on_tile.add_child(boulder)
	#TODO: instantiate scene, if there's a card there - remove it (also remove the effects)

func set_up_new_level(
	level: int, 
	enemy_tile_generator: EnemyTileGenerator, 
	enemy_manager: EnemyManager) -> void:
	for row in grid:
		for tile in row:
			if tile == null:
				continue
			tile.queue_free()
	grid = []

	set_up_new_grid()
	generate_enemies(enemy_tile_generator, enemy_manager)

func perform_boulder_move():
	var back_to_front = true

	var rows = range(0, ROWS.size())
	rows.reverse()
	for r in rows:
		var inds = range(0, ROWS[r])
		if back_to_front:
			inds.reverse()
		for c in inds:
			var tile = get_tile(r, c)
			if tile == null or tile.boulder == null:
				continue
			if tile.boulder.is_grounded():
				continue

			var to_tile: GridTile = tile.get_bottom_neighbor()
			if to_tile == null or to_tile.boulder != null:
				continue

			await _move_boulder(tile.boulder, tile, tile.get_bottom_neighbor())

	boulder_move_finished.emit()

func _move_boulder(b: Boulder, from_tile: GridTile, to_tile: GridTile) -> void:
	assert(to_tile != null and to_tile.boulder == null)
	_clear_for_boulder(to_tile)
	b.reparent(to_tile)
	b.position = Vector2.ZERO
	to_tile.boulder = b
	from_tile.boulder = null

	await get_tree().create_timer(0.1).timeout

func _clear_for_boulder(to_tile: GridTile) -> void:
	var card = to_tile.get_card()
	if card:
		card.remove_from_board()

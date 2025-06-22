extends Node2D

var GridTile = preload("res://scenes/grid_tile.tscn")
#@export var gridTile: GridTile


#var ROWS = 6
#var COLUMNS = 2
const FLIPPED = false
const ROWS = [4, 3, 4, 3, 4]

func _ready():
	var sample_tile = GridTile.instantiate()
	var h = sample_tile.get_texture_size().y
	var w = sample_tile.get_texture_size().x
	print(h)
	print(w)
	for i in range(0, ROWS.size()):
		var y = position.y + h * i / 2
		if i % 2 == 1:
			continue
		
		for j in range(0, ROWS[i]):
			var grid_tile = GridTile.instantiate()
			grid_tile.position.x = position.x + j * w * 3 / 2
			grid_tile.position.y = y
			add_child(grid_tile)
			
	for i in range(0, ROWS.size()):
		var y = position.y + h * i / 2
		if i % 2 == 0:
			continue
		
		for j in range(0, ROWS[i]):
			var grid_tile = GridTile.instantiate()
			grid_tile.position.x = position.x + j * w * 3 / 2 + w * 3 / 4
			grid_tile.position.y = y
			add_child(grid_tile)
		
	

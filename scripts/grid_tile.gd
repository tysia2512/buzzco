class_name GridTile extends Node2D

@export var row: int = 0
@export var column: int = 0

@onready var sprite: Sprite2D = $Sprite2D

func get_texture_size():
	return sprite.get_texture_size() 
	
func set_grid_position(_row: int, _column: int):
	row = _row
	column = _column

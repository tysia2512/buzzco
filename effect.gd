class_name Effect extends Node2D

@export var multiplier: int = 1

var _from_card: Card = null
var _tile: GridTile = null

func place(from_card: Card, on_tile: GridTile) -> void:
	print("Place effect: ", self)
	_from_card = from_card
	_tile = on_tile
	_tile.add_effect(self)
	
func remove() -> void:
	_tile.remove_effect(self)
	
func apply(total: int) -> int:
	return total * multiplier

class_name EnemyTileGenerator extends Node2D

@onready var goon_hornet_enemy = preload("res://scenes/goon_hornet_enemy.tscn")

var _level: int = 1

func prepare_level(level: int) -> void:
	_level = level
	
func generate_enemy() -> Enemy:
	return goon_hornet_enemy.instantiate()
	

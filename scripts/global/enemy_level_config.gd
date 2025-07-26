extends Node

var goon_hornet_enemy_scn = preload("res://scenes/goon_hornet_enemy.tscn")

var ENEMY_TYPES = [goon_hornet_enemy_scn]

enum EnemyType {
	GOON_HORNET_ENEMY
}

var _ENEMY_TYPE_TO_SCENE = {
	EnemyType.GOON_HORNET_ENEMY: goon_hornet_enemy_scn
}

class IntRange:
	var lower: int
	var upper: int

	func _init(l, u):
		lower = l
		upper = u

# I'm assuming these are non-conflicting
var _config = [
	# 1
	{
		EnemyType.GOON_HORNET_ENEMY: IntRange.new(2, 2)
	},
	# 2
	{
		EnemyType.GOON_HORNET_ENEMY: IntRange.new(3, 3)
	},
	# 3
	{
		EnemyType.GOON_HORNET_ENEMY: IntRange.new(4, 5)
	}
]

func get_config(level: int) -> Dictionary:
	if level > _config.size():
		return _config[_config.size() - 1]
	
	return _config[level - 1]

func get_enemy_scene(enemy_type: EnemyType) -> PackedScene:
	return _ENEMY_TYPE_TO_SCENE[enemy_type]

class_name EnemyTileGenerator extends Node2D

@onready var goon_hornet_enemy = preload("res://scenes/goon_hornet_enemy.tscn")

var _level: int = 1

func prepare_level(level: int) -> void:
	_level = level
	
func generate_enemy() -> Enemy:
	return goon_hornet_enemy.instantiate()

func generate_enemies(rows: Array) -> Array:
	var enemy_slots = rows.reduce(func(a, b): return a + b, 0)
	var enemies = []
	var config = EnemyLevelConfig.get_config(_level)
	for type in config:
		var cnt = Utils.rand_in_range(config[type].lower, config[type].upper)
		for i in range(0, cnt):
			enemies.append(EnemyLevelConfig.get_enemy_scene(type))

	assert(enemies.size() <= enemy_slots)
	
	while enemies.size() < enemy_slots:
		enemies.append(null)
	
	enemies.shuffle()

	var en_i = 0
	var ret = []
	ret.resize(rows.size())
	for i in range(0, rows.size()):
		ret[i] = []

	for i in range(0, rows.size()):
		ret[i].resize(rows[i])
		for j in range(0, rows[i]):
			ret[i][j] = enemies[en_i]
			en_i += 1

	return ret

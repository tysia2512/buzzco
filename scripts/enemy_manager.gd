class_name EnemyManager extends Node2D

signal enemy_turn_finished

@onready var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint

func perform_turn():
	print("ENEMY TURN")
	var original_scale = Vector2(scale.x, scale.y)
	self.scale = Vector2(2.0, 2.0)
	print("scale: ", scale, " and original: ", original_scale)
	await get_tree().create_timer(1.0).timeout
	self.scale = original_scale
	await get_tree().create_timer(0.1).timeout
	enemy_turn_finished.emit()

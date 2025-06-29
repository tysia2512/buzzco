class_name EnemyManager extends Node2D

signal enemy_turn_finished

@onready var enemy_spawn_point: EnemySpawnPoint = $EnemySpawnPoint

func perform_turn():
	for enemy in enemy_spawn_point.get_enemies():
		await _perform_enemy_attack(enemy)
		
	enemy_turn_finished.emit()

func _perform_enemy_attack(enemy: Enemy) -> void:
	var original_scale = Vector2(scale.x, scale.y)
	enemy.scale = Vector2(2.0, 2.0)
	await enemy.attack()
	enemy.scale = original_scale
	await get_tree().create_timer(0.1).timeout
	

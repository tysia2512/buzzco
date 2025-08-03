class_name Enemy extends Node2D

var _enemy: GenericEnemy
var tile: EnemyTile

func attack():
	await _enemy.attack()

func spawn_boulder():
	await _enemy.spawn_boulder()

func highlight() -> void:
	await _enemy.highlight()

func set_tile(tile: EnemyTile):
	_enemy.tile = tile

func get_enemy_died_signal():
	return _enemy.enemy_died

func get_boulder_spawned_signal():
	return _enemy.boulder_spawned

func get_deal_damage_to_player_signal():
	return _enemy.deal_damage_to_player

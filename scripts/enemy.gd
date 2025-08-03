class_name Enemy extends Node2D

signal deal_damage_to_player
signal enemy_died
signal boulder_spawned

var _enemy: GenericEnemy:
	set(value):
		_enemy = value
		_connect_signals()
		
var tile: EnemyTile

func attack():
	await _enemy.attack()

func spawn_boulder():
	await _enemy.spawn_boulder()

func highlight() -> void:
	await _enemy.highlight()

func set_tile(tile: EnemyTile):
	_enemy.tile = tile

func _connect_signals():
	_enemy.deal_damage_to_player.connect(func(pts): deal_damage_to_player.emit(pts))
	_enemy.enemy_died.connect(func(): enemy_died.emit(self))
	_enemy.boulder_spawned.connect(func(tile): boulder_spawned.emit(tile))

func receive_damage(pts: int) -> void:
	_enemy.receive_damage(pts)

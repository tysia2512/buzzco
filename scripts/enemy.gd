class_name Enemy extends Node2D

var enemy: GenericEnemy
var tile: EnemyTile

func attack():
	await enemy.attack()

func spawn_boulder():
	await enemy.spawn_boulder()

func highlight() -> void:
	await enemy.highlight()

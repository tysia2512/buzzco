class_name Enemy extends Node2D

var enemy: GenericEnemy

func attack():
	await enemy.attack()

func highlight() -> void:
	await enemy.highlight()

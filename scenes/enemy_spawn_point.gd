class_name EnemySpawnPoint extends Node2D

@onready var goon_hornet_enemy_scene: PackedScene = preload("res://scenes/goon_hornet_enemy.tscn")

@export var goon_hornet_enemy_count: int = 2

var _enemies: Array = []

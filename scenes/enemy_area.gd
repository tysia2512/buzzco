class_name EnemyArea extends Area2D

func get_enemy():
	return $"../..".get_parent()

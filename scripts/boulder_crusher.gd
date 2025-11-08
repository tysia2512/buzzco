class_name BoulderCrusher extends Node2D

signal boulder_destroyed

@export var uses_left: int = 1

func can_destroy_boulder() -> bool:
	return uses_left > 0

func on_destroy_boulder() -> void:
	uses_left -= 1
	boulder_destroyed.emit()

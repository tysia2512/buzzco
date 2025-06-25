class_name LevelPlay extends Node2D

signal level_cleared
signal player_moved

func prepare_level(level: int):
	pass

func _on_cheat_button_pressed() -> void:
	level_cleared.emit()

extends Control

@onready var point_counter_label: Label = $PointCounterLabel

@onready var points = 0

func _on_launch_attack_button_pressed() -> void:
	var grid: Grid = $"../CardMovementManager/Grid"
	if grid == null:
		return
	points += grid.get_points()
	point_counter_label.text = str(points)

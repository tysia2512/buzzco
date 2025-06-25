extends Node2D

@onready var card_movement_manager: Node2D = $CardMovementManager


func _on_launch_attack_button_pressed() -> void:
	PollenManager.launch_assault()

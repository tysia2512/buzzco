extends Node2D

@onready var card_movement_manager: Node2D = $CardMovementManager

func ready():
	card_movement_manager.pollen_manager = card_movement_manager

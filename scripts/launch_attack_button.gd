extends Button

signal perform_player_action

func _pressed() -> void:
	print("BUTTON PRESSED")
	PollenManager.add_pollen(GameState.POLLEN_RECOVERED_ON_ASSAULT)
	perform_player_action.emit()
	

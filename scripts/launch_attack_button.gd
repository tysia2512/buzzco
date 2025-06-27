extends Button

signal perform_player_action

func _pressed() -> void:
	print("BUTTON PRESSED")
	perform_player_action.emit()
	
	

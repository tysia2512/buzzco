extends Button

signal perform_player_action

func _pressed() -> void:
	PollenManager.add_pollen(GameState.POLLEN_RECOVERED_ON_ASSAULT)
	perform_player_action.emit()
	
func _process(delta: float):
	disabled =! GameState.is_player_turn()

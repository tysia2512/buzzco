extends Button

signal launch_assault

func _pressed() -> void:
	PollenManager.add_pollen(GameState.POLLEN_RECOVERED_ON_ASSAULT)
	launch_assault.emit()
	
func _process(delta: float):
	disabled =! GameState.is_player_turn()

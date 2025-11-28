class_name LaunchAttackButton extends Button

signal launch_assault

var grid: Grid

func _pressed() -> void:
	PollenManager.add_pollen(GameState.POLLEN_RECOVERED_ON_ASSAULT)
	launch_assault.emit()
	
func _process(delta: float):
	if grid.get_cards().is_empty():
		disabled = true
	else:
		disabled = !GameState.is_player_turn()

	if grid != null:
		text = "Launch assault (" + str(grid.get_points()) + ")"

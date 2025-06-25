extends Label

func _process(delta: float):
	text = str(GameState.player_health)
	

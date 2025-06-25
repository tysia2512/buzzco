extends Label

func _process(delta: float):
	set_text(str(PollenManager.pollen))

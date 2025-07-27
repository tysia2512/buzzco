extends Label

func _ready() -> void:
	if !GameState.POLLEN_ENABLED:
		visible = false
		
func _process(delta: float):
	set_text(str(PollenManager.pollen))

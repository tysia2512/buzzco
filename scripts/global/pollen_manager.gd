extends Node2D

var pollen = GameState.START_POLLEN
var _pollen_regained_from_launch = 3

func can_afford_pollen(x: int) -> bool:
	return pollen >= x

func pay_pollen(x: int) -> void:
	pollen -= x
	
func add_pollen(x: int) -> void:
	pollen += x

func launch_assault():
	pollen += _pollen_regained_from_launch

func set_up_new_level():
	pollen = GameState.START_POLLEN
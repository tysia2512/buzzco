extends Node2D

var pollen = 5
var _pollen_regained_from_launch = 3

func can_afford_pollen(x: int) -> bool:
	return true

func pay_pollen(x: int) -> void:
	pollen -= x

func launch_assault():
	pollen += _pollen_regained_from_launch

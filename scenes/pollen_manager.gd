extends Node2D

var pollen = 50

func can_afford_pollen(x: int) -> bool:
	return true

func pay_pollen(x: int) -> void:
	pollen -= x

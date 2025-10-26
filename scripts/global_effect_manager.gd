class_name GlobalEffectManager extends Node2D

@export var height: int = 100
@export var width: int = 100

var _global_effects = []

func _init() -> void:
	pass

func add_global_effect(effect: GlobalEffect) -> void:
	add_child(effect)
	effect.remove.connect(_remove_effect)
	_global_effects.append(effect)
	_redraw()

func _redraw() -> void:
	pass

func get_global_effects() -> Array:
	return _global_effects

func _remove_effect(effect: GlobalEffect) -> void:
	_global_effects.erase(effect)
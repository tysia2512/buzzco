class_name GlobalEffectManager extends Node2D

@export var item_height: int = 100
@export var max_height: int = 500

var _global_effects = []

func _ready() -> void:
	pass

func add_global_effect(effect: GlobalEffect) -> void:
	_global_effects.append(effect)
	add_child(effect)
	effect.remove.connect(_remove_effect)
	_redraw()

func _redraw() -> void:
	if _global_effects.size() * item_height <= max_height:
		for i in range(_global_effects.size()):
			_global_effects[i].scale = Vector2.ONE * (
				1.0 * item_height / (_global_effects[i]._sprite.texture.get_height()))
			_global_effects[i].position = Vector2(0, i * item_height + item_height / 2)
	else:
		var offset = (max_height - item_height) / (_global_effects.size() - 1)
		for i in range(_global_effects.size()):
			_global_effects[i].scale = Vector2.ONE * (
				1.0 * item_height / (_global_effects[i]._sprite.texture.get_height()))
			_global_effects[i].position = Vector2(0, i * offset + item_height / 2)

func get_global_effects() -> Array:
	return _global_effects

func _remove_effect(effect: GlobalEffect) -> void:
	_global_effects.erase(effect)
	_redraw()

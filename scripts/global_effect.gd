class_name GlobalEffect extends Node2D

signal remove(effect: GlobalEffect)

var parent_card: TypedCard = null
var _sprite: GlobalEffectSprite = null:
	set(value):
		_sprite = value

func _ready():
	_sprite = get_children().filter(func(c): return c is GlobalEffectSprite)[0] as GlobalEffectSprite

# Should override
func should_react_to_damage() -> bool:
	return false

# Should override
func process_damage(damage: int) -> int:
	return damage

func remove_self() -> void:
	parent_card.remove_global_effect(self)
	remove.emit(self)
	queue_free()

func resize_to_height(new_height: int) -> void:
	var scale_factor = new_height / _sprite.texture.get_height()
	_sprite.scale = Vector2(scale_factor, scale_factor)

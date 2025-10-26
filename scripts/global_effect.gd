class_name GlobalEffect extends Node2D

var parent_card: TypedCard = null

signal remove(effect: GlobalEffect)

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

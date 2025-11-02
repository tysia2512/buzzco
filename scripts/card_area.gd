class_name CardArea extends Area2D

func get_card() -> TypedCard:
	return get_children().filter(func(x): return x is CardCollisionPolygon)[0].card

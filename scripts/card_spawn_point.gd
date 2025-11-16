class_name CardSpawnPoint extends Node2D

@onready var W: int = get_viewport().get_visible_rect().size.y * 0.6

func get_cards():
	return get_children().filter(func(x): return x is TypedCard).filter(func(c): return c.card.is_in_hand())

func _arrange_cards():
	Utils.arrange_cards(W, Vector2.ZERO, get_cards())
	
func update():
	_arrange_cards()
	
func add_card(card: TypedCard):
	card.reparent(self)
	_arrange_cards()
	
func spawn_card(card: TypedCard, from: Vector2):
	add_child(card)
	var position_start = from - global_position
	card.position = position_start

	_arrange_cards()

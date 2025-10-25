# to extend this method you need to implement _on_card_card_removed_from_board that will handle the signal from the card
# and will queue free
class_name TypedCard extends Node2D

var tween: Tween
@export var texture: Texture2D:
	set(value):
		texture = value
		if card != null:
			card.texture = value

@export var card: GenericCard:
	set(value):
		card = value
		if texture:
			card.texture = texture
		card.card_removed_from_board.connect(_remove)
		card.set_collision_shape_card(self)

var card_type: GenericCard.CardType:
	get():
		return card.card_type
		
func remove_from_board():
	card.remove_from_the_board()
	
func _on_remove(_tile: GridTile) -> void:
	pass

func _remove(_tile: GridTile) -> void:
	_on_remove(_tile)
	queue_free()

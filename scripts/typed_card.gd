# to extend this method you need to implement _on_card_card_removed_from_board that will handle the signal from the card
# and will queue free
class_name TypedCard extends Node2D

var tween: Tween
@export var card: GenericCard:
	set(value):
		card = value
		card.card_removed_from_board.connect(_remove)
		
func remove_from_board():
	card.remove_from_the_board()
	
func _remove(_tile: GridTile) -> void:
	queue_free()

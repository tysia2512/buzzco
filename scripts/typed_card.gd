# to extend this method you need to implement _on_card_card_removed_from_board that will handle the signal from the card
# and will queue free
class_name TypedCard extends Node2D

var card: GenericCard
var tween: Tween

func remove_from_board():
	card.remove_from_the_board()
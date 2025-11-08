# to extend this method you need to implement _on_card_card_removed_from_board that will handle the signal from the card
# and will queue free
class_name TypedCard extends Node2D

signal card_selected_for_attack(card: TypedCard)
signal card_selected_in_shop(card: TypedCard)

var global_effect: GlobalEffect = null

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
		card.card_selected_for_attack.connect(func ():
			card_selected_for_attack.emit(self)
		)
		card.card_selected_in_shop.connect(func ():
			card_selected_in_shop.emit(self)
		)
		card.set_collision_shape_card(self)

@export var card_type: CardIndex.CardType

var card_class: GenericCard.CardClass:
	get():
		return card.card_class

func _ready():
	assert(card != null, "TypedCard: card is not set")	
		
func remove_from_board():
	card.remove_from_the_board()
	
func _on_remove(_tile: GridTile) -> void:
	pass

func _remove(_tile: GridTile) -> void:
	_on_remove(_tile)
	queue_free()

func remove_global_effect(effect: GlobalEffect) -> void:
	if global_effect == effect:
		global_effect = null

func get_boulder_crusher() -> BoulderCrusher:
	for child in get_children():
		if child is BoulderCrusher:
			return child as BoulderCrusher
	return null

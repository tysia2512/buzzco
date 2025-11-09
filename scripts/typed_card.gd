# to extend this method you need to implement _on_card_card_removed_from_board that will handle the signal from the card
# and will queue free
class_name TypedCard extends Node2D

signal card_selected_for_attack(card: TypedCard)
signal card_selected(card: TypedCard)

var global_effect: GlobalEffect = null

var tween: Tween
@export var texture: Texture2D:
	set(value):
		texture = value
		if card != null:
			card.texture = value

@export var card: GenericCard

@export var card_type: CardIndex.CardType

var card_class: GenericCard.CardClass:
	get():
		return card.card_class

func _ready():
	assert(card != null, "TypedCard: card is not set")
	assert(texture != null, "TypedCard: texture is not set")



	card.texture = texture
	card.set_collision_shape_card(self)

	card.card_removed_from_board.connect(_remove)
	card.card_selected.connect(func ():
		card_selected.emit(self)
	)
	card.card_selected_for_attack.connect(func ():
		print("TypedCard emitting card_selected_for_attack")
		card_selected_for_attack.emit(self)
	)

	for child in get_children():
		if child is OnCardPlaced:
			card.card_placed.connect(child.on_card_placed)
		else:
			card.card_placed.connect(func (tile: GridTile):
				ActionEventBus.perform_player_action.emit()
			)

		
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


func animate_selection() -> void:
	var s = scale
	scale = s * 1.2
	await get_tree().create_timer(0.8).timeout
	scale = s

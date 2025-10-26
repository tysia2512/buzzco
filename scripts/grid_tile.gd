class_name GridTile extends Tile

signal add_global_effect(effect: GlobalEffect)

@onready var sprite: Sprite2D = $Sprite2D

var boulder: Boulder = null
var _card: TypedCard = null
var _effects = {}

func get_texture_size():
	return sprite.get_texture_size() 
	
func put_card(card: TypedCard) -> void:
	_card = card
	
# Should only be called by the card
func remove_card() -> void:
	_card = null
	
func get_card() -> TypedCard:
	return _card

func place_global_effect(effect: GlobalEffect) -> void:
	add_global_effect.emit(effect)

func add_effect(effect: Effect) -> void:
	_effects[effect] = true
	
func remove_effect(effect: Effect) -> void:
	print("Removing effect: ", effect)
	_effects.erase(effect)
	print("Effects left: ", _effects)
	
func get_effects() -> Array:
	return _effects.keys().map(func(key): return key as Effect)

func get_bottom_left_corner_position() -> Vector2:
	return $BottomLeftCorner.position

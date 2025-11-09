class_name PortectorBeeCard extends TypedCard

@onready var shield_scene: PackedScene = preload("res://scenes/shield.tscn")

const _attack_value = 1
const _name = "Protector Bee"

func _init() -> void:
	visible = false

func _ready():
	card.attack_value = _attack_value
	card.card_name = _name
	visible = true
	super._ready()

func remove_shield() -> void:
	global_effect = null

func _on_card_card_placed(tile: GridTile) -> void:
	global_effect = shield_scene.instantiate()
	global_effect.parent_card = self
	tile.place_global_effect(global_effect)

func _on_remove(tile: GridTile) -> void:
	if global_effect != null:
		global_effect.remove_self()
		global_effect = null

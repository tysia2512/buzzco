class_name DrillOperatorBeeCard extends TypedCard

const _attack_value = 1
const _name = "Drill Operator Bee"

var _no_drill_texture = preload("res://assets/no_drill_operator.png")
var _has_drill: bool = true

func _init() -> void:
	visible = false

func _ready():
	card = $Card
	card.attack_value = _attack_value
	card.card_name = _name
	visible = true

func _on_boulder_crusher_boulder_destroyed() -> void:
	_has_drill = false
	card.texture = _no_drill_texture

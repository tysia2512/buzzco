class_name DrillOperatorBeeCard extends TypedCard

var _no_drill_texture = preload("res://assets/no_drill_operator.png")
var _has_drill: bool = true

func _on_boulder_crusher_boulder_destroyed() -> void:
	_has_drill = false
	card.texture = _no_drill_texture

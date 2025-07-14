class_name HealthDisplay extends Node2D

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_label: Label = $HealthLabel

var _max_health
var _current_health

func set_max_health(h: int):
	_max_health = h
	health_bar.max_value = h
	_update_health_label()

func set_current_health(h: int):
	_current_health = h
	health_bar.value = _current_health
	_update_health_label()

func _update_health_label():
	health_label.text = "{0} / {1}".format([_current_health, _max_health])

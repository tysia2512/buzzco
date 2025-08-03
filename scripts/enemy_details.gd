class_name EnemyDetails extends Node2D

@onready var stats_label: Label = $StatsLabel
@onready var description_label: Label = $DescriptionLabel

func _ready():
	z_index = ZLayers.ON_HOVER_TOOLTIP

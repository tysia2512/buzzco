class_name EnemyDetails extends Node2D

@onready var stats_label: AutoSizeLabel = $StatsLabel
@onready var description_label: AutoSizeLabel = $DescriptionLabel

func _ready():
	z_index = ZLayers.ON_HOVER_TOOLTIP

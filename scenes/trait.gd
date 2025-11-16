class_name Trait extends Node2D

@export var texture: Texture2D

@export var trait_type: CardIndex.CardTrait

func process_attack():
	pass

func should_stay_after_attack():
	return false

var is_active = true

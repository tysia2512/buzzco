extends Node2D

func get_texture_size():
	return get_child(0).get_texture_size()

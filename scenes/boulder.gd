class_name Boulder extends Node2D

func is_grounded() -> bool:
	var bottom_neighbor = _get_tile().get_bottom_neighbor()
	if bottom_neighbor == null:
		return true
	if bottom_neighbor.boulder != null and bottom_neighbor.boulder.is_grounded():
		return true
	return false
	
func _get_tile() -> GridTile:
	return get_parent() as GridTile

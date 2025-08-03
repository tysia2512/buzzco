class_name EnemyTile extends Tile

var _enemy: Enemy

func set_enemy(e: Enemy) -> void:
	add_child(e)
	_enemy = e
	e.set_tile(self)
	
func get_enemy() -> Enemy:
	return _enemy

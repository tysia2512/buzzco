class_name EnemyTile extends Tile

var _enemy: Enemy

func clear_enemy() -> Enemy:
	var enemy = _enemy
	if _enemy != null:
		enemy.set_tile(null)
		_enemy = null
	return enemy

func set_enemy(e: Enemy) -> void:
	add_child(e)
	_enemy = e
	e.set_tile(self)
	
func get_enemy() -> Enemy:
	return _enemy

func move_enemy(e: Enemy) -> void:
	_enemy = e
	e.set_tile(self)
	e.reparent(self, false)
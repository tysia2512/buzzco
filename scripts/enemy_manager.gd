class_name EnemyManager extends Node2D

signal enemy_turn_finished
signal enemy_selected
signal deal_damage_to_player

var _enemies = []

func perform_turn():
	for enemy in _enemies:
		assert(enemy is Enemy)
		await _perform_enemy_attack(enemy)
		
	enemy_turn_finished.emit()

func _perform_enemy_attack(enemy: Enemy) -> void:
	var original_scale = Vector2(scale.x, scale.y)
	enemy.scale = Vector2(2.0, 2.0)
	await enemy.attack()
	enemy.scale = original_scale
	await get_tree().create_timer(0.1).timeout
	
func get_enemies() -> Array:
	return _enemies

func _handle_enemy_death(enemy: Enemy) -> void:
	_enemies = _enemies.filter(func(e): return e != enemy)
	enemy.queue_free()

func set_enemies(enemies: Array) -> void:
	for e in enemies:
		assert(e is Enemy)
		e.enemy.enemy_died.connect(_handle_enemy_death)
		e.enemy.deal_damage_to_player.connect(func(dmg): deal_damage_to_player.emit(dmg))
	_enemies = enemies

func _input(event: InputEvent) -> void:
	if GameState.turn_stage != GameState.TurnStage.SPECIFIC_INPUT:
		return

	if GameState.specific_input != GameState.SpecificInput.ENEMY_SELECT:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if event.pressed:
			var enemy = _check_for_enemy()
			if enemy == null:
				return
			await enemy.highlight()
			enemy_selected.emit(enemy)

func _check_for_enemy() -> Enemy:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 2 ** (GameState.EMEMY_COLLISION_LAYER - 1)
	var result = space_state.intersect_point(parameters, 1)
	if result.is_empty():
		return null
	var enemy_area = result[0].collider
	if !(enemy_area is EnemyArea):
		return null
	return enemy_area.get_enemy()

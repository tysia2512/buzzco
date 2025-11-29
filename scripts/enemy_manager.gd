class_name EnemyManager extends Node2D

signal enemy_turn_finished
signal enemy_selected
signal deal_damage_to_player
signal boulder_spawned
signal all_enemies_dead

var _enemies = []

func perform_turn():
	for enemy in _enemies:
		assert(enemy is Enemy)
		await _spawn_boulder(enemy)

	for enemy in _enemies:
		assert(enemy is Enemy)
		await _perform_enemy_attack(enemy)

	ActionEventBus.move_enemies.emit()
		
	enemy_turn_finished.emit()

func _spawn_boulder(enemy: Enemy) -> void:
	await enemy.spawn_boulder()
	await get_tree().create_timer(0.1).timeout

func _perform_enemy_attack(enemy: Enemy) -> void:
	await enemy.attack()
	await get_tree().create_timer(0.1).timeout
	
func get_enemies() -> Array:
	return _enemies

func _handle_enemy_death(enemy: Enemy) -> void:
	_enemies = _enemies.filter(func(e): return e != enemy)
	enemy.queue_free()
	if _enemies.is_empty():
		all_enemies_dead.emit()

func _handle_boulder_spawned(on_tile: Tile) -> void:
	boulder_spawned.emit(on_tile)

func set_enemies(enemies: Array) -> void:
	for e in enemies:
		assert(e is Enemy)
		e.enemy_died.connect(_handle_enemy_death)
		e.deal_damage_to_player.connect(func(dmg): deal_damage_to_player.emit(dmg))
		e.boulder_spawned.connect(_handle_boulder_spawned)
	_enemies = enemies

func _input(event: InputEvent) -> void:
	if GameState.turn_stage != GameState.TurnStage.SPECIFIC_INPUT:
		return

	if GameState.specific_input != GameState.SpecificInput.ENEMY_OR_BEE_SELECT:
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
